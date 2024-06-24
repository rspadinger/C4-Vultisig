/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Interface, type ContractRunner } from "ethers";
import type {
  IApproveAndCallReceiver,
  IApproveAndCallReceiverInterface,
} from "../../../../../artifacts/hardhat-vultisig/contracts/interfaces/IApproveAndCallReceiver";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "token",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "extraData",
        type: "bytes",
      },
    ],
    name: "receiveApproval",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IApproveAndCallReceiver__factory {
  static readonly abi = _abi;
  static createInterface(): IApproveAndCallReceiverInterface {
    return new Interface(_abi) as IApproveAndCallReceiverInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): IApproveAndCallReceiver {
    return new Contract(
      address,
      _abi,
      runner
    ) as unknown as IApproveAndCallReceiver;
  }
}
