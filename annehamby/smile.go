package main

import (
	"errors"
	"flag"
	"fmt"
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"sync"
	"time"
)

func check(in, out string) (int, error) {
	missing := 0
	folders, err := filepath.Glob(filepath.Join(in, "20*"))
	if err != nil {
		return -1, err
	}
	sort.Strings(folders)
	for _, folder := range folders {
		video := filepath.Base(folder)
		wav := filepath.Join(folder, "vocals.wav")
		info, err := os.Stat(wav)
		if err != nil && errors.Is(err, fs.ErrNotExist) {
			fmt.Printf("input file missing for %s\n", video)
			continue
		} else if err != nil {
			return -1, err
		}
		if info.Size() == 0 {
			fmt.Printf("input file has size 0: %s\n", video)
			continue
		}
		_, err = os.Stat(filepath.Join(out, video))
		if err != nil && errors.Is(err, fs.ErrNotExist) {
			// no output folder means we haven't tried to run it
			continue
		} else if err != nil {
			return -1, err
		}
		outfo, err := os.Stat(filepath.Join(out, video, "prosodyAcf.csv"))
		if err != nil && errors.Is(err, fs.ErrNotExist) {
			fmt.Printf("output file missing for %s\n", video)
			missing++
			continue
		} else if err != nil {
			return -1, err
		}
		if outfo.Size() == 0 {
			fmt.Printf("ouput file has size 0: %s\n", video)
			continue
		}
	}
	return missing, nil
}

func main() {
	flagConfig := flag.String("config", "/bsuhome/annehamby/osk/prosodyAcf.conf", "OpenSMILE config file")
	flagWorkDir := flag.String("workdir", "/bsuhome/annehamby/osk", "working directory")
	flagWavs := flag.String("wavs", "/bsushare/annehamby-shared/oskwavs", "wav folder")
	flagOutput := flag.String("output", "/bsushare/annehamby-shared/oskoutput", "output folder")
	flagJobs := flag.Int("jobs", 0, "concurrent jobs")
	flagBatch := flag.Int("batch", 480, "number of analyses to do per task")
	flagDryRun := flag.Bool("n", false, "dry run")
	flagCheck := flag.Bool("check", false, "check input vs output, requires argc==2")
	flag.Parse()

	if *flagCheck {
		missing, err := check(flag.Arg(0), flag.Arg(1))
		if err != nil {
			log.Fatal(err)
		}
		if missing > 0 {
			fmt.Printf("missing %d output files\n", missing)
		}
		os.Exit(missing)
	}

	//match := regexp.MustCompile(`20[0-9]{2}_[0-9]+_.*`)
	glob, err := filepath.Glob(filepath.Join(*flagWavs, "20*"))
	if err != nil {
		log.Fatal(err)
	}
	sort.Strings(glob)
	total := len(glob)
	log.Printf("total: %d", total)
	start := 0
	end := 0
	if task := os.Getenv("SLURM_ARRAY_TASK_ID"); task != "" {
		x, err := strconv.Atoi(task)
		if err != nil {
			log.Fatal(err)
		}
		x--
		start = x * *flagBatch
	}
	end = start + *flagBatch
	if start > total {
		log.Fatalf("start out of bounds, start: %d, total: %d", start, total)
	}
	if end >= total {
		end = total - 1
	}
	if *flagJobs <= 0 {
		*flagJobs = runtime.GOMAXPROCS(0)
	}
	throttle := make(chan struct{}, *flagJobs)
	for i := 0; i < *flagJobs; i++ {
		throttle <- struct{}{}
	}

	var wg sync.WaitGroup
	wg.Add(end - start)
	for _, folder := range glob[start:end] {
		folder := folder
		<-throttle
		go func() {
			defer func() {
				wg.Done()
				throttle <- struct{}{}
			}()
			video := filepath.Base(folder)
			infile := filepath.Join(folder, "vocals.wav")
			outdir := filepath.Join(*flagOutput, video)
			outfile := filepath.Join(outdir, "prosodyAcf.csv")
			if *flagDryRun {
				log.Printf("mkdir: %s", outdir)
			} else {
				if err := os.MkdirAll(outdir, 0755); err != nil {
					log.Fatal(err)
				}
			}
			cmd := exec.Command("SMILExtract", "-C", *flagConfig, "-I", infile, "-csvoutput", outfile)
			if *flagDryRun {
				log.Print(cmd)
				time.Sleep(5 * time.Second)
			} else {
				cmd.Stderr = os.Stderr
				cmd.Stdout = os.Stdout
				cmd.Dir = *flagWorkDir
				err := cmd.Run()
				if err != nil {
					log.Print(err)
				}
			}
		}()
	}
	wg.Wait()
}
