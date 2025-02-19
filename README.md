# HumanEval-X: Hand-Written Evaluation Set on Scilab Code

This is an evaluation harness for the HumanEval problem solving dataset
described in the paper "[Evaluating Large Language Models Trained on
Code](https://arxiv.org/abs/2107.03374)".Buy based on the Scilab programming language.

This repository extended from the original [HumanEval](https://github.com/openai/human-eval)

## Installation

Check out and install this repository:
```
$ git clone https://github.com/qqyfly/human-eval-x
$ pip install -e human-eval-x
```

## Usage

**This program exists to run untrusted model-generated Scilab code. Users are strongly
encouraged not to do so outside of a robust security sandbox. See the comment in
`execution.py` for more information and instructions.**

After following the above instructions to enable execution, generate samples
and save them in the following JSON Lines (jsonl) format, where each sample is
formatted into a single line like so:
```
{"task_id": "Corresponding HumanEval task ID", "completion": "Completion only without the prompt"}
```
We provide `example_problem.jsonl` and `example_solutions.jsonl` under `data`
to illustrate the format and help with debugging.

Here is nearly functional example code (you just have to provide
`generate_one_completion` to make it work) that saves generated completions to
`samples.jsonl`.
```
from human_eval.data import write_jsonl, read_problems

problems = read_problems()

num_samples_per_task = 200
samples = [
    dict(task_id=task_id, completion=generate_one_completion(problems[task_id]["prompt"]))
    for task_id in problems
    for _ in range(num_samples_per_task)
]
write_jsonl("samples.jsonl", samples)
```

To evaluate the samples, run
```
$ evaluate_functional_correctness samples.jsonl
Reading samples...
32800it [00:01, 23787.50it/s]
Running test suites...
100%|...| 32800/32800 [16:11<00:00, 33.76it/s]
Writing results to samples.jsonl_results.jsonl...
100%|...| 32800/32800 [00:00<00:00, 42876.84it/s]
{'pass@1': ..., 'pass@10': ..., 'pass@100': ...}
```
This script provides more fine-grained information in a new file ending in
`<input_path>_results.jsonl`. Each row now contains whether the completion
`passed` along with the execution `result` which is one of "passed", "timed
out", or "failed".

Because there is no unbiased way of estimating pass@k when there are fewer
samples than k, the script does not evaluate pass@k for these cases. To
evaluate with other k values, pass `--k=<comma-separated-values-here>`. For
other options, see
```
$ evaluate_functional_correctness --help
```
However, we recommend that you use the default values for the rest.

## Known Issues

While evaluation uses very little memory, you might see the following error
message when the system is running out of RAM. Since this may cause some
correct programs to fail, we recommend that you free some memory and try again.
```
malloc: can't allocate region
```
