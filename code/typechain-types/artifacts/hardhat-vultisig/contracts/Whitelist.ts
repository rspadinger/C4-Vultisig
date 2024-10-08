/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumberish,
  BytesLike,
  FunctionFragment,
  Result,
  Interface,
  EventFragment,
  AddressLike,
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedLogDescription,
  TypedListener,
  TypedContractMethod,
} from "../../../common";

export interface WhitelistInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "addBatchWhitelist"
      | "addWhitelistedAddress"
      | "allowedWhitelistIndex"
      | "checkWhitelist"
      | "contributed"
      | "isBlacklisted"
      | "isSelfWhitelistDisabled"
      | "locked"
      | "maxAddressCap"
      | "oracle"
      | "owner"
      | "pool"
      | "renounceOwnership"
      | "setAllowedWhitelistIndex"
      | "setBlacklisted"
      | "setIsSelfWhitelistDisabled"
      | "setLocked"
      | "setMaxAddressCap"
      | "setOracle"
      | "setPool"
      | "setVultisig"
      | "transferOwnership"
      | "vultisig"
      | "whitelistCount"
      | "whitelistIndex"
  ): FunctionFragment;

  getEvent(nameOrSignatureOrTopic: "OwnershipTransferred"): EventFragment;

  encodeFunctionData(
    functionFragment: "addBatchWhitelist",
    values: [AddressLike[]]
  ): string;
  encodeFunctionData(
    functionFragment: "addWhitelistedAddress",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "allowedWhitelistIndex",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "checkWhitelist",
    values: [AddressLike, AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "contributed",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "isBlacklisted",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "isSelfWhitelistDisabled",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "locked", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "maxAddressCap",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "oracle", values?: undefined): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(functionFragment: "pool", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setAllowedWhitelistIndex",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setBlacklisted",
    values: [AddressLike, boolean]
  ): string;
  encodeFunctionData(
    functionFragment: "setIsSelfWhitelistDisabled",
    values: [boolean]
  ): string;
  encodeFunctionData(functionFragment: "setLocked", values: [boolean]): string;
  encodeFunctionData(
    functionFragment: "setMaxAddressCap",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setOracle",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setPool",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setVultisig",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "vultisig", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "whitelistCount",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "whitelistIndex",
    values: [AddressLike]
  ): string;

  decodeFunctionResult(
    functionFragment: "addBatchWhitelist",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "addWhitelistedAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "allowedWhitelistIndex",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "checkWhitelist",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "contributed",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "isBlacklisted",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "isSelfWhitelistDisabled",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "locked", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "maxAddressCap",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "oracle", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pool", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setAllowedWhitelistIndex",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setBlacklisted",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setIsSelfWhitelistDisabled",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setLocked", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setMaxAddressCap",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setOracle", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "setPool", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setVultisig",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "vultisig", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "whitelistCount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "whitelistIndex",
    data: BytesLike
  ): Result;
}

export namespace OwnershipTransferredEvent {
  export type InputTuple = [previousOwner: AddressLike, newOwner: AddressLike];
  export type OutputTuple = [previousOwner: string, newOwner: string];
  export interface OutputObject {
    previousOwner: string;
    newOwner: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface Whitelist extends BaseContract {
  connect(runner?: ContractRunner | null): Whitelist;
  waitForDeployment(): Promise<this>;

  interface: WhitelistInterface;

  queryFilter<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;
  queryFilter<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;

  on<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  on<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  once<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  once<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  listeners<TCEvent extends TypedContractEvent>(
    event: TCEvent
  ): Promise<Array<TypedListener<TCEvent>>>;
  listeners(eventName?: string): Promise<Array<Listener>>;
  removeAllListeners<TCEvent extends TypedContractEvent>(
    event?: TCEvent
  ): Promise<this>;

  addBatchWhitelist: TypedContractMethod<
    [whitelisted: AddressLike[]],
    [void],
    "nonpayable"
  >;

  addWhitelistedAddress: TypedContractMethod<
    [whitelisted: AddressLike],
    [void],
    "nonpayable"
  >;

  allowedWhitelistIndex: TypedContractMethod<[], [bigint], "view">;

  checkWhitelist: TypedContractMethod<
    [from: AddressLike, to: AddressLike, amount: BigNumberish],
    [void],
    "nonpayable"
  >;

  contributed: TypedContractMethod<[to: AddressLike], [bigint], "view">;

  isBlacklisted: TypedContractMethod<[account: AddressLike], [boolean], "view">;

  isSelfWhitelistDisabled: TypedContractMethod<[], [boolean], "view">;

  locked: TypedContractMethod<[], [boolean], "view">;

  maxAddressCap: TypedContractMethod<[], [bigint], "view">;

  oracle: TypedContractMethod<[], [string], "view">;

  owner: TypedContractMethod<[], [string], "view">;

  pool: TypedContractMethod<[], [string], "view">;

  renounceOwnership: TypedContractMethod<[], [void], "nonpayable">;

  setAllowedWhitelistIndex: TypedContractMethod<
    [newIndex: BigNumberish],
    [void],
    "nonpayable"
  >;

  setBlacklisted: TypedContractMethod<
    [blacklisted: AddressLike, flag: boolean],
    [void],
    "nonpayable"
  >;

  setIsSelfWhitelistDisabled: TypedContractMethod<
    [newFlag: boolean],
    [void],
    "nonpayable"
  >;

  setLocked: TypedContractMethod<[newLocked: boolean], [void], "nonpayable">;

  setMaxAddressCap: TypedContractMethod<
    [newCap: BigNumberish],
    [void],
    "nonpayable"
  >;

  setOracle: TypedContractMethod<
    [newOracle: AddressLike],
    [void],
    "nonpayable"
  >;

  setPool: TypedContractMethod<[newPool: AddressLike], [void], "nonpayable">;

  setVultisig: TypedContractMethod<
    [newVultisig: AddressLike],
    [void],
    "nonpayable"
  >;

  transferOwnership: TypedContractMethod<
    [newOwner: AddressLike],
    [void],
    "nonpayable"
  >;

  vultisig: TypedContractMethod<[], [string], "view">;

  whitelistCount: TypedContractMethod<[], [bigint], "view">;

  whitelistIndex: TypedContractMethod<[account: AddressLike], [bigint], "view">;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "addBatchWhitelist"
  ): TypedContractMethod<[whitelisted: AddressLike[]], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "addWhitelistedAddress"
  ): TypedContractMethod<[whitelisted: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "allowedWhitelistIndex"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "checkWhitelist"
  ): TypedContractMethod<
    [from: AddressLike, to: AddressLike, amount: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "contributed"
  ): TypedContractMethod<[to: AddressLike], [bigint], "view">;
  getFunction(
    nameOrSignature: "isBlacklisted"
  ): TypedContractMethod<[account: AddressLike], [boolean], "view">;
  getFunction(
    nameOrSignature: "isSelfWhitelistDisabled"
  ): TypedContractMethod<[], [boolean], "view">;
  getFunction(
    nameOrSignature: "locked"
  ): TypedContractMethod<[], [boolean], "view">;
  getFunction(
    nameOrSignature: "maxAddressCap"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "oracle"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "owner"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "pool"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "renounceOwnership"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setAllowedWhitelistIndex"
  ): TypedContractMethod<[newIndex: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setBlacklisted"
  ): TypedContractMethod<
    [blacklisted: AddressLike, flag: boolean],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setIsSelfWhitelistDisabled"
  ): TypedContractMethod<[newFlag: boolean], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setLocked"
  ): TypedContractMethod<[newLocked: boolean], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setMaxAddressCap"
  ): TypedContractMethod<[newCap: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setOracle"
  ): TypedContractMethod<[newOracle: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setPool"
  ): TypedContractMethod<[newPool: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setVultisig"
  ): TypedContractMethod<[newVultisig: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "transferOwnership"
  ): TypedContractMethod<[newOwner: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "vultisig"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "whitelistCount"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "whitelistIndex"
  ): TypedContractMethod<[account: AddressLike], [bigint], "view">;

  getEvent(
    key: "OwnershipTransferred"
  ): TypedContractEvent<
    OwnershipTransferredEvent.InputTuple,
    OwnershipTransferredEvent.OutputTuple,
    OwnershipTransferredEvent.OutputObject
  >;

  filters: {
    "OwnershipTransferred(address,address)": TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;
    OwnershipTransferred: TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;
  };
}
