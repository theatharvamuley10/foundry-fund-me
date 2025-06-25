-include .env

deploy-alfajores:; forge script script/DeployFundMe.s.sol --rpc-url $(ALFAJORES_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) --ffi -vvvv

