Getting Started

Requirements
git
You'll know you did it right if you can run git --version and you see a response like git version x.x.x
foundry
You'll know you did it right if you can run forge --version and you see a response like forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)

Quickstart
git clone https://github.com/Cyfrin/foundry-fund-me-cu
cd foundry-fund-me-cu
make

Optional Gitpod
If you can't or don't want to run and install locally, you can work with this repo in Gitpod. If you do this, you can skip the clone this repo part.

Open in Gitpod

Usage
Deploy
forge script script/DeployFundMe.s.sol
Testing
We talk about 4 test tiers in the video.

Unit
Integration
Forked
Staging
This repo we cover #1 and #3.

forge test
or

// Only run test functions matching the specified regex pattern.

"forge test -m testFunctionName" is deprecated. Please use 

forge test --match-test testFunctionName
or

forge test --fork-url $SEPOLIA_RPC_URL
Test Coverage
forge coverage