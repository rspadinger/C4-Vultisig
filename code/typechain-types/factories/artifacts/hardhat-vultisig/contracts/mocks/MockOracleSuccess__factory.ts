/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type { Signer, ContractDeployTransaction, ContractRunner } from "ethers";
import type { NonPayableOverrides } from "../../../../../common";
import type {
  MockOracleSuccess,
  MockOracleSuccessInterface,
} from "../../../../../artifacts/hardhat-vultisig/contracts/mocks/MockOracleSuccess";

const _abi = [
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "baseAmount",
        type: "uint256",
      },
    ],
    name: "peek",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b50610252806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c806306fdde031461003b5780637861d26914610059575b600080fd5b610043610089565b6040516100509190610168565b60405180910390f35b610073600480360381019061006e91906101c5565b6100c6565b6040516100809190610201565b60405180910390f35b60606040518060400160405280601281526020017f56554c542f45544820556e697633545741500000000000000000000000000000815250905090565b60006714d1120d7b1600009050919050565b600081519050919050565b600082825260208201905092915050565b60005b838110156101125780820151818401526020810190506100f7565b60008484015250505050565b6000601f19601f8301169050919050565b600061013a826100d8565b61014481856100e3565b93506101548185602086016100f4565b61015d8161011e565b840191505092915050565b60006020820190508181036000830152610182818461012f565b905092915050565b600080fd5b6000819050919050565b6101a28161018f565b81146101ad57600080fd5b50565b6000813590506101bf81610199565b92915050565b6000602082840312156101db576101da61018a565b5b60006101e9848285016101b0565b91505092915050565b6101fb8161018f565b82525050565b600060208201905061021660008301846101f2565b9291505056fea2646970667358221220483e9e26214dbeeeedf8d204402fb586faa23bf895809dba6f9d912c59fe0a4a64736f6c63430008180033";

type MockOracleSuccessConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: MockOracleSuccessConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class MockOracleSuccess__factory extends ContractFactory {
  constructor(...args: MockOracleSuccessConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(overrides || {});
  }
  override deploy(overrides?: NonPayableOverrides & { from?: string }) {
    return super.deploy(overrides || {}) as Promise<
      MockOracleSuccess & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): MockOracleSuccess__factory {
    return super.connect(runner) as MockOracleSuccess__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): MockOracleSuccessInterface {
    return new Interface(_abi) as MockOracleSuccessInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): MockOracleSuccess {
    return new Contract(address, _abi, runner) as unknown as MockOracleSuccess;
  }
}
