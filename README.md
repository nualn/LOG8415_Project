# LOG8415 FINAL PROJECT

## Requirements

- Python 3.6

## How to run

- Clone the repository
- Make sure all the .sh files are executable

### How to setup and run the benchmark

- Change the directory to the benchmark folder
- Install the requirements with `pip install -r requirements.txt`
- Make sure you have aws credentials set up correctly in your environment
- Setup the infrastructure and deploy the cluster & single instance with `./script.sh setup`
  - Note: There is a bug in the version of ubuntu used that sometimes the ssh connection to hang after installing a package. If this happens, press Ctrl-C once and the script should continue running.
- Run the benchmark with `./script.sh benchmark`

### How to setup the design pattern implementations and run a test
