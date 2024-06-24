/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type {
  Signer,
  AddressLike,
  ContractDeployTransaction,
  ContractRunner,
} from "ethers";
import type { NonPayableOverrides } from "../../../../../../common";
import type {
  UniswapV3Oracle,
  UniswapV3OracleInterface,
} from "../../../../../../artifacts/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_pool",
        type: "address",
      },
      {
        internalType: "address",
        name: "_baseToken",
        type: "address",
      },
      {
        internalType: "address",
        name: "_WETH",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "BASE_AMOUNT",
    outputs: [
      {
        internalType: "uint128",
        name: "",
        type: "uint128",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "PERIOD",
    outputs: [
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "WETH",
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
    name: "baseToken",
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
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "pure",
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
] as const;

const _bytecode =
  "0x60e06040523480156200001157600080fd5b5060405162001ffa38038062001ffa833981810160405281019062000037919062000146565b8273ffffffffffffffffffffffffffffffffffffffff1660808173ffffffffffffffffffffffffffffffffffffffff16815250508173ffffffffffffffffffffffffffffffffffffffff1660a08173ffffffffffffffffffffffffffffffffffffffff16815250508073ffffffffffffffffffffffffffffffffffffffff1660c08173ffffffffffffffffffffffffffffffffffffffff1681525050505050620001a2565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006200010e82620000e1565b9050919050565b620001208162000101565b81146200012c57600080fd5b50565b600081519050620001408162000115565b92915050565b600080600060608486031215620001625762000161620000dc565b5b600062000172868287016200012f565b935050602062000185868287016200012f565b925050604062000198868287016200012f565b9150509250925092565b60805160a05160c051611e0c620001ee6000396000818161028401526102e3015260008181610263015261030d0152600081816101a5015281816101db015261022b0152611e0c6000f3fe608060405234801561001057600080fd5b506004361061007d5760003560e01c80637861d2691161005b5780637861d269146100dc578063ad5c46481461010c578063b4d1d7951461012a578063c55dae63146101485761007d565b806306fdde031461008257806316f0115b146100a057806325de1092146100be575b600080fd5b61008a610166565b6040516100979190611052565b60405180910390f35b6100a86101a3565b6040516100b591906110b5565b60405180910390f35b6100c66101c7565b6040516100d391906110fb565b60405180910390f35b6100f660048036038101906100f19190611160565b6101d3565b604051610103919061119c565b60405180910390f35b6101146102e1565b60405161012191906110b5565b60405180910390f35b610132610305565b60405161013f91906111d6565b60405180910390f35b61015061030b565b60405161015d91906110b5565b60405180910390f35b60606040518060400160405280601381526020017f56554c542f5745544820556e6976335457415000000000000000000000000000815250905090565b7f000000000000000000000000000000000000000000000000000000000000000081565b670de0b6b3a764000081565b6000806101ff7f000000000000000000000000000000000000000000000000000000000000000061032f565b905060008163ffffffff1661070863ffffffff161061021e5781610222565b6107085b905060006102507f00000000000000000000000000000000000000000000000000000000000000008361052f565b905060006102a882670de0b6b3a76400007f00000000000000000000000000000000000000000000000000000000000000007f0000000000000000000000000000000000000000000000000000000000000000610749565b905068056bc75e2d63100000605f87836102c29190611220565b6102cc9190611220565b6102d69190611291565b945050505050919050565b7f000000000000000000000000000000000000000000000000000000000000000081565b61070881565b7f000000000000000000000000000000000000000000000000000000000000000081565b60008060008373ffffffffffffffffffffffffffffffffffffffff16633850c7bd6040518163ffffffff1660e01b815260040160e060405180830381865afa15801561037f573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906103a391906113d2565b50505093509350505060008161ffff16116103f3576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016103ea906114c0565b60405180910390fd5b6000808573ffffffffffffffffffffffffffffffffffffffff1663252c09d78460018761042091906114e0565b61042a9190611516565b6040518263ffffffff1660e01b81526004016104469190611582565b608060405180830381865afa158015610463573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906104879190611602565b93505050915080610518578573ffffffffffffffffffffffffffffffffffffffff1663252c09d760006040518263ffffffff1660e01b81526004016104cc91906116a4565b608060405180830381865afa1580156104e9573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061050d9190611602565b909150905050809250505b814261052491906116bf565b945050505050919050565b6000808263ffffffff1603610579576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161057090611743565b60405180910390fd5b6000600267ffffffffffffffff81111561059657610595611763565b5b6040519080825280602002602001820160405280156105c45781602001602082028036833780820191505090505b50905082816000815181106105dc576105db611792565b5b602002602001019063ffffffff16908163ffffffff168152505060008160018151811061060c5761060b611792565b5b602002602001019063ffffffff16908163ffffffff168152505060008473ffffffffffffffffffffffffffffffffffffffff1663883bdbfd836040518263ffffffff1660e01b8152600401610661919061187f565b600060405180830381865afa15801561067e573d6000803e3d6000fd5b505050506040513d6000823e3d601f19601f820116820180604052508101906106a79190611a7d565b5090506000816000815181106106c0576106bf611792565b5b6020026020010151826001815181106106dc576106db611792565b5b60200260200101516106ee9190611af5565b90508463ffffffff16816107029190611b54565b935060008160060b12801561072c575060008563ffffffff16826107269190611bbe565b60060b14155b1561074057838061073c90611bef565b9450505b50505092915050565b60008061075586610955565b90506fffffffffffffffffffffffffffffffff80168173ffffffffffffffffffffffffffffffffffffffff161161086f5760008173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff166107c09190611220565b90508373ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16106108305761082b7801000000000000000000000000000000000000000000000000876fffffffffffffffffffffffffffffffff1683610e22565b610867565b61086681876fffffffffffffffffffffffffffffffff167801000000000000000000000000000000000000000000000000610e22565b5b92505061094c565b60006108b18273ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1668010000000000000000610e22565b90508373ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff161061091957610914700100000000000000000000000000000000876fffffffffffffffffffffffffffffffff1683610e22565b610948565b61094781876fffffffffffffffffffffffffffffffff16700100000000000000000000000000000000610e22565b5b9250505b50949350505050565b60008060008360020b1261096c578260020b61097a565b8260020b61097990611c41565b5b90507ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff276186109a690611c89565b62ffffff168111156109ed576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016109e490611d1d565b60405180910390fd5b6000806001831603610a1057700100000000000000000000000000000000610a22565b6ffffcb933bd6fad37aa2d162d1a5940015b70ffffffffffffffffffffffffffffffffff16905060006002831614610a655760806ffff97272373d413259a46990580e213a82610a609190611220565b901c90505b60006004831614610a935760806ffff2e50f5f656932ef12357cf3c7fdcc82610a8e9190611220565b901c90505b60006008831614610ac15760806fffe5caca7e10e4e61c3624eaa0941cd082610abc9190611220565b901c90505b60006010831614610aef5760806fffcb9843d60f6159c9db58835c92664482610aea9190611220565b901c90505b60006020831614610b1d5760806fff973b41fa98c081472e6896dfb254c082610b189190611220565b901c90505b60006040831614610b4b5760806fff2ea16466c96a3843ec78b326b5286182610b469190611220565b901c90505b60006080831614610b795760806ffe5dee046a99a2a811c461f1969c305382610b749190611220565b901c90505b6000610100831614610ba85760806ffcbe86c7900a88aedcffc83b479aa3a482610ba39190611220565b901c90505b6000610200831614610bd75760806ff987a7253ac413176f2b074cf7815e5482610bd29190611220565b901c90505b6000610400831614610c065760806ff3392b0822b70005940c7a398e4b70f382610c019190611220565b901c90505b6000610800831614610c355760806fe7159475a2c29b7443b29c7fa6e889d982610c309190611220565b901c90505b6000611000831614610c645760806fd097f3bdfd2022b8845ad8f792aa582582610c5f9190611220565b901c90505b6000612000831614610c935760806fa9f746462d870fdf8a65dc1f90e061e582610c8e9190611220565b901c90505b6000614000831614610cc25760806f70d869a156d2a1b890bb3df62baf32f782610cbd9190611220565b901c90505b6000618000831614610cf15760806f31be135f97d08fd981231505542fcfa682610cec9190611220565b901c90505b600062010000831614610d215760806f09aa508b5b7a84e1c677de54f3e99bc982610d1c9190611220565b901c90505b600062020000831614610d505760806e5d6af8dedb81196699c329225ee60482610d4b9190611220565b901c90505b600062040000831614610d7e5760806d2216e584f5fa1ea926041bedfe9882610d799190611220565b901c90505b600062080000831614610daa5760806b048a170391f7dc42444e8fa282610da59190611220565b901c90505b60008460020b1315610de557807fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff610de29190611291565b90505b600064010000000082610df89190611d3d565b14610e04576001610e07565b60005b60ff16602082901c610e199190611d6e565b92505050919050565b6000806000801985870985870292508281108382030391505060008103610e5c5760008411610e5057600080fd5b83820492505050610fbb565b808411610e6857600080fd5b600084868809905082811182039150808303925060008560018719610e8d9190611d6e565b1690508086049550808404935060018182600003040190508083610eb19190611220565b8417935060006002876003610ec69190611220565b1890508087610ed59190611220565b6002610ee19190611da2565b81610eec9190611220565b90508087610efa9190611220565b6002610f069190611da2565b81610f119190611220565b90508087610f1f9190611220565b6002610f2b9190611da2565b81610f369190611220565b90508087610f449190611220565b6002610f509190611da2565b81610f5b9190611220565b90508087610f699190611220565b6002610f759190611da2565b81610f809190611220565b90508087610f8e9190611220565b6002610f9a9190611da2565b81610fa59190611220565b90508085610fb39190611220565b955050505050505b9392505050565b600081519050919050565b600082825260208201905092915050565b60005b83811015610ffc578082015181840152602081019050610fe1565b60008484015250505050565b6000601f19601f8301169050919050565b600061102482610fc2565b61102e8185610fcd565b935061103e818560208601610fde565b61104781611008565b840191505092915050565b6000602082019050818103600083015261106c8184611019565b905092915050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061109f82611074565b9050919050565b6110af81611094565b82525050565b60006020820190506110ca60008301846110a6565b92915050565b60006fffffffffffffffffffffffffffffffff82169050919050565b6110f5816110d0565b82525050565b600060208201905061111060008301846110ec565b92915050565b6000604051905090565b600080fd5b600080fd5b6000819050919050565b61113d8161112a565b811461114857600080fd5b50565b60008135905061115a81611134565b92915050565b60006020828403121561117657611175611120565b5b60006111848482850161114b565b91505092915050565b6111968161112a565b82525050565b60006020820190506111b1600083018461118d565b92915050565b600063ffffffff82169050919050565b6111d0816111b7565b82525050565b60006020820190506111eb60008301846111c7565b92915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b600061122b8261112a565b91506112368361112a565b92508282026112448161112a565b9150828204841483151761125b5761125a6111f1565b5b5092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b600061129c8261112a565b91506112a78361112a565b9250826112b7576112b6611262565b5b828204905092915050565b6112cb81611074565b81146112d657600080fd5b50565b6000815190506112e8816112c2565b92915050565b60008160020b9050919050565b611304816112ee565b811461130f57600080fd5b50565b600081519050611321816112fb565b92915050565b600061ffff82169050919050565b61133e81611327565b811461134957600080fd5b50565b60008151905061135b81611335565b92915050565b600060ff82169050919050565b61137781611361565b811461138257600080fd5b50565b6000815190506113948161136e565b92915050565b60008115159050919050565b6113af8161139a565b81146113ba57600080fd5b50565b6000815190506113cc816113a6565b92915050565b600080600080600080600060e0888a0312156113f1576113f0611120565b5b60006113ff8a828b016112d9565b97505060206114108a828b01611312565b96505060406114218a828b0161134c565b95505060606114328a828b0161134c565b94505060806114438a828b0161134c565b93505060a06114548a828b01611385565b92505060c06114658a828b016113bd565b91505092959891949750929550565b7f4e49000000000000000000000000000000000000000000000000000000000000600082015250565b60006114aa600283610fcd565b91506114b582611474565b602082019050919050565b600060208201905081810360008301526114d98161149d565b9050919050565b60006114eb82611327565b91506114f683611327565b9250828201905061ffff8111156115105761150f6111f1565b5b92915050565b600061152182611327565b915061152c83611327565b92508261153c5761153b611262565b5b828206905092915050565b6000819050919050565b600061156c61156761156284611327565b611547565b61112a565b9050919050565b61157c81611551565b82525050565b60006020820190506115976000830184611573565b92915050565b6115a6816111b7565b81146115b157600080fd5b50565b6000815190506115c38161159d565b92915050565b60008160060b9050919050565b6115df816115c9565b81146115ea57600080fd5b50565b6000815190506115fc816115d6565b92915050565b6000806000806080858703121561161c5761161b611120565b5b600061162a878288016115b4565b945050602061163b878288016115ed565b935050604061164c878288016112d9565b925050606061165d878288016113bd565b91505092959194509250565b6000819050919050565b600061168e61168961168484611669565b611547565b61112a565b9050919050565b61169e81611673565b82525050565b60006020820190506116b96000830184611695565b92915050565b60006116ca826111b7565b91506116d5836111b7565b9250828203905063ffffffff8111156116f1576116f06111f1565b5b92915050565b7f4250000000000000000000000000000000000000000000000000000000000000600082015250565b600061172d600283610fcd565b9150611738826116f7565b602082019050919050565b6000602082019050818103600083015261175c81611720565b9050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b600081519050919050565b600082825260208201905092915050565b6000819050602082019050919050565b6117f6816111b7565b82525050565b600061180883836117ed565b60208301905092915050565b6000602082019050919050565b600061182c826117c1565b61183681856117cc565b9350611841836117dd565b8060005b8381101561187257815161185988826117fc565b975061186483611814565b925050600181019050611845565b5085935050505092915050565b600060208201905081810360008301526118998184611821565b905092915050565b600080fd5b6118af82611008565b810181811067ffffffffffffffff821117156118ce576118cd611763565b5b80604052505050565b60006118e1611116565b90506118ed82826118a6565b919050565b600067ffffffffffffffff82111561190d5761190c611763565b5b602082029050602081019050919050565b600080fd5b6000611936611931846118f2565b6118d7565b905080838252602082019050602084028301858111156119595761195861191e565b5b835b81811015611982578061196e88826115ed565b84526020840193505060208101905061195b565b5050509392505050565b600082601f8301126119a1576119a06118a1565b5b81516119b1848260208601611923565b91505092915050565b600067ffffffffffffffff8211156119d5576119d4611763565b5b602082029050602081019050919050565b60006119f96119f4846119ba565b6118d7565b90508083825260208201905060208402830185811115611a1c57611a1b61191e565b5b835b81811015611a455780611a3188826112d9565b845260208401935050602081019050611a1e565b5050509392505050565b600082601f830112611a6457611a636118a1565b5b8151611a748482602086016119e6565b91505092915050565b60008060408385031215611a9457611a93611120565b5b600083015167ffffffffffffffff811115611ab257611ab1611125565b5b611abe8582860161198c565b925050602083015167ffffffffffffffff811115611adf57611ade611125565b5b611aeb85828601611a4f565b9150509250929050565b6000611b00826115c9565b9150611b0b836115c9565b92508282039050667fffffffffffff81137fffffffffffffffffffffffffffffffffffffffffffffffffff8000000000000082121715611b4e57611b4d6111f1565b5b92915050565b6000611b5f826115c9565b9150611b6a836115c9565b925082611b7a57611b79611262565b5b600160000383147fffffffffffffffffffffffffffffffffffffffffffffffffff8000000000000083141615611bb357611bb26111f1565b5b828205905092915050565b6000611bc9826115c9565b9150611bd4836115c9565b925082611be457611be3611262565b5b828207905092915050565b6000611bfa826112ee565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8000008203611c2c57611c2b6111f1565b5b600182039050919050565b6000819050919050565b6000611c4c82611c37565b91507f80000000000000000000000000000000000000000000000000000000000000008203611c7e57611c7d6111f1565b5b816000039050919050565b6000611c94826112ee565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8000008203611cc657611cc56111f1565b5b816000039050919050565b7f5400000000000000000000000000000000000000000000000000000000000000600082015250565b6000611d07600183610fcd565b9150611d1282611cd1565b602082019050919050565b60006020820190508181036000830152611d3681611cfa565b9050919050565b6000611d488261112a565b9150611d538361112a565b925082611d6357611d62611262565b5b828206905092915050565b6000611d798261112a565b9150611d848361112a565b9250828201905080821115611d9c57611d9b6111f1565b5b92915050565b6000611dad8261112a565b9150611db88361112a565b9250828203905081811115611dd057611dcf6111f1565b5b9291505056fea264697066735822122076beb92b15fd75f0134f25ca9eb1b8b6228c381839bcd2acd93ebf77346d9fad64736f6c63430008180033";

type UniswapV3OracleConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: UniswapV3OracleConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class UniswapV3Oracle__factory extends ContractFactory {
  constructor(...args: UniswapV3OracleConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    _pool: AddressLike,
    _baseToken: AddressLike,
    _WETH: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(
      _pool,
      _baseToken,
      _WETH,
      overrides || {}
    );
  }
  override deploy(
    _pool: AddressLike,
    _baseToken: AddressLike,
    _WETH: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ) {
    return super.deploy(_pool, _baseToken, _WETH, overrides || {}) as Promise<
      UniswapV3Oracle & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): UniswapV3Oracle__factory {
    return super.connect(runner) as UniswapV3Oracle__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): UniswapV3OracleInterface {
    return new Interface(_abi) as UniswapV3OracleInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): UniswapV3Oracle {
    return new Contract(address, _abi, runner) as unknown as UniswapV3Oracle;
  }
}
