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
import type { NonPayableOverrides } from "../../../../common";
import type {
  Whitelist,
  WhitelistInterface,
} from "../../../../artifacts/hardhat-vultisig/contracts/Whitelist";

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "Blacklisted",
    type: "error",
  },
  {
    inputs: [],
    name: "Locked",
    type: "error",
  },
  {
    inputs: [],
    name: "MaxAddressCapOverflow",
    type: "error",
  },
  {
    inputs: [],
    name: "NotVultisig",
    type: "error",
  },
  {
    inputs: [],
    name: "NotWhitelisted",
    type: "error",
  },
  {
    inputs: [],
    name: "SelfWhitelistDisabled",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address[]",
        name: "whitelisted",
        type: "address[]",
      },
    ],
    name: "addBatchWhitelist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "whitelisted",
        type: "address",
      },
    ],
    name: "addWhitelistedAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "allowedWhitelistIndex",
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
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "checkWhitelist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "contributed",
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
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "isBlacklisted",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "isSelfWhitelistDisabled",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "locked",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "maxAddressCap",
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
  {
    inputs: [],
    name: "oracle",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pool",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "newIndex",
        type: "uint256",
      },
    ],
    name: "setAllowedWhitelistIndex",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "blacklisted",
        type: "address",
      },
      {
        internalType: "bool",
        name: "flag",
        type: "bool",
      },
    ],
    name: "setBlacklisted",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bool",
        name: "newFlag",
        type: "bool",
      },
    ],
    name: "setIsSelfWhitelistDisabled",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bool",
        name: "newLocked",
        type: "bool",
      },
    ],
    name: "setLocked",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "newCap",
        type: "uint256",
      },
    ],
    name: "setMaxAddressCap",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOracle",
        type: "address",
      },
    ],
    name: "setOracle",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newPool",
        type: "address",
      },
    ],
    name: "setPool",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newVultisig",
        type: "address",
      },
    ],
    name: "setVultisig",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "vultisig",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "whitelistCount",
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
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "whitelistIndex",
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
  {
    stateMutability: "payable",
    type: "receive",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b5061002d61002261005c60201b60201c565b61006460201b60201c565b6729a2241af62c00006001819055506001600260006101000a81548160ff021916908315150217905550610128565b600033905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b6116d7806101376000396000f3fe60806040526004361061016a5760003560e01c80638da5cb5b116100d1578063cf3090121161008a578063dac936b911610064578063dac936b914610628578063f2624b5d14610651578063f2fde38b1461067c578063fe575a87146106a5576102a0565b8063cf309012146105ab578063d01dd6d2146105d6578063d86638b6146105ff576102a0565b80638da5cb5b14610499578063995c5e9d146104c4578063a07177fc14610501578063a6c477081461052a578063b30eaada14610555578063b4c7d7a114610580576102a0565b80635da2a8a8116101235780635da2a8a81461039d578063715018a6146103c857806378458925146103df5780637adbf973146104085780637dc0d1d014610431578063886d35181461045c576102a0565b806316f0115b146102a5578063211e28b6146102d057806329975b43146102f957806342d5eb2e1461032257806342e112221461034b5780634437152a14610374576102a0565b366102a057600260019054906101000a900460ff16156101b6576040517feb7141b400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600860006101c26106e2565b73ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff1615610241576040517f09550c7700000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b61025161024c6106e2565b6106ea565b6102596106e2565b73ffffffffffffffffffffffffffffffffffffffff166108fc349081150290604051600060405180830381858888f1935050505015801561029e573d6000803e3d6000fd5b005b600080fd5b3480156102b157600080fd5b506102ba61078d565b6040516102c79190611197565b60405180910390f35b3480156102dc57600080fd5b506102f760048036038101906102f291906111f4565b6107b7565b005b34801561030557600080fd5b50610320600480360381019061031b919061124d565b6107dc565b005b34801561032e57600080fd5b50610349600480360381019061034491906112b0565b6107f0565b005b34801561035757600080fd5b50610372600480360381019061036d9190611303565b610be7565b005b34801561038057600080fd5b5061039b6004803603810190610396919061124d565b610bf9565b005b3480156103a957600080fd5b506103b2610c45565b6040516103bf919061133f565b60405180910390f35b3480156103d457600080fd5b506103dd610c4f565b005b3480156103eb57600080fd5b50610406600480360381019061040191906111f4565b610c63565b005b34801561041457600080fd5b5061042f600480360381019061042a919061124d565b610c88565b005b34801561043d57600080fd5b50610446610cd4565b6040516104539190611197565b60405180910390f35b34801561046857600080fd5b50610483600480360381019061047e919061124d565b610cfe565b604051610490919061133f565b60405180910390f35b3480156104a557600080fd5b506104ae610d47565b6040516104bb9190611197565b60405180910390f35b3480156104d057600080fd5b506104eb60048036038101906104e6919061124d565b610d70565b6040516104f8919061133f565b60405180910390f35b34801561050d57600080fd5b50610528600480360381019061052391906113bf565b610db9565b005b34801561053657600080fd5b5061053f610e11565b60405161054c9190611197565b60405180910390f35b34801561056157600080fd5b5061056a610e39565b604051610577919061133f565b60405180910390f35b34801561058c57600080fd5b50610595610e43565b6040516105a2919061141b565b60405180910390f35b3480156105b757600080fd5b506105c0610e5a565b6040516105cd919061141b565b60405180910390f35b3480156105e257600080fd5b506105fd60048036038101906105f89190611436565b610e71565b005b34801561060b57600080fd5b5061062660048036038101906106219190611303565b610ed4565b005b34801561063457600080fd5b5061064f600480360381019061064a919061124d565b610ee6565b005b34801561065d57600080fd5b50610666610f31565b604051610673919061133f565b60405180910390f35b34801561068857600080fd5b506106a3600480360381019061069e919061124d565b610f3b565b005b3480156106b157600080fd5b506106cc60048036038101906106c7919061124d565b610fbe565b6040516106d9919061141b565b60405180910390f35b600033905090565b6000600760008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020540361078a57600560008154610740906114a5565b919050819055600760008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055505b50565b6000600460009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6107bf611014565b80600260006101000a81548160ff02191690831515021790555050565b6107e4611014565b6107ed816106ea565b50565b60028054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1661082f6106e2565b73ffffffffffffffffffffffffffffffffffffffff161461087c576040517f3e3312c400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600460009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614801561090c57506108dc610d47565b73ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614155b15610be257600260009054906101000a900460ff1615610958576040517f0f2e5b6c00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600860008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16156109dc576040517f09550c7700000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60006006541480610a2d5750600654600760008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054115b15610a64576040517f584a793800000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16637861d269836040518263ffffffff1660e01b8152600401610ac1919061133f565b602060405180830381865afa158015610ade573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610b029190611502565b905060015481600960008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054610b52919061152f565b1115610b8a576040517f2834ecec00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b80600960008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254610bd9919061152f565b92505081905550505b505050565b610bef611014565b8060018190555050565b610c01611014565b80600460006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000600154905090565b610c57611014565b610c616000611092565b565b610c6b611014565b80600260016101000a81548160ff02191690831515021790555050565b610c90611014565b80600360006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6000600760008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6000600960008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b610dc1611014565b60005b82829050811015610e0c57610dff838383818110610de557610de4611563565b5b9050602002016020810190610dfa919061124d565b6106ea565b8080600101915050610dc4565b505050565b600060028054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6000600654905090565b6000600260019054906101000a900460ff16905090565b6000600260009054906101000a900460ff16905090565b610e79611014565b80600860008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055505050565b610edc611014565b8060068190555050565b610eee611014565b806002806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000600554905090565b610f43611014565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1603610fb2576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610fa990611615565b60405180910390fd5b610fbb81611092565b50565b6000600860008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff169050919050565b61101c6106e2565b73ffffffffffffffffffffffffffffffffffffffff1661103a610d47565b73ffffffffffffffffffffffffffffffffffffffff1614611090576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161108790611681565b60405180910390fd5b565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061118182611156565b9050919050565b61119181611176565b82525050565b60006020820190506111ac6000830184611188565b92915050565b600080fd5b600080fd5b60008115159050919050565b6111d1816111bc565b81146111dc57600080fd5b50565b6000813590506111ee816111c8565b92915050565b60006020828403121561120a576112096111b2565b5b6000611218848285016111df565b91505092915050565b61122a81611176565b811461123557600080fd5b50565b60008135905061124781611221565b92915050565b600060208284031215611263576112626111b2565b5b600061127184828501611238565b91505092915050565b6000819050919050565b61128d8161127a565b811461129857600080fd5b50565b6000813590506112aa81611284565b92915050565b6000806000606084860312156112c9576112c86111b2565b5b60006112d786828701611238565b93505060206112e886828701611238565b92505060406112f98682870161129b565b9150509250925092565b600060208284031215611319576113186111b2565b5b60006113278482850161129b565b91505092915050565b6113398161127a565b82525050565b60006020820190506113546000830184611330565b92915050565b600080fd5b600080fd5b600080fd5b60008083601f84011261137f5761137e61135a565b5b8235905067ffffffffffffffff81111561139c5761139b61135f565b5b6020830191508360208202830111156113b8576113b7611364565b5b9250929050565b600080602083850312156113d6576113d56111b2565b5b600083013567ffffffffffffffff8111156113f4576113f36111b7565b5b61140085828601611369565b92509250509250929050565b611415816111bc565b82525050565b6000602082019050611430600083018461140c565b92915050565b6000806040838503121561144d5761144c6111b2565b5b600061145b85828601611238565b925050602061146c858286016111df565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60006114b08261127a565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82036114e2576114e1611476565b5b600182019050919050565b6000815190506114fc81611284565b92915050565b600060208284031215611518576115176111b2565b5b6000611526848285016114ed565b91505092915050565b600061153a8261127a565b91506115458361127a565b925082820190508082111561155d5761155c611476565b5b92915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b600082825260208201905092915050565b7f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160008201527f6464726573730000000000000000000000000000000000000000000000000000602082015250565b60006115ff602683611592565b915061160a826115a3565b604082019050919050565b6000602082019050818103600083015261162e816115f2565b9050919050565b7f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572600082015250565b600061166b602083611592565b915061167682611635565b602082019050919050565b6000602082019050818103600083015261169a8161165e565b905091905056fea264697066735822122086ea6d36c1dfb61851b998ec9db23a6b9321339f0003656f6f84a9aac553f1bb64736f6c63430008180033";

type WhitelistConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: WhitelistConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Whitelist__factory extends ContractFactory {
  constructor(...args: WhitelistConstructorParams) {
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
      Whitelist & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): Whitelist__factory {
    return super.connect(runner) as Whitelist__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): WhitelistInterface {
    return new Interface(_abi) as WhitelistInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): Whitelist {
    return new Contract(address, _abi, runner) as unknown as Whitelist;
  }
}
