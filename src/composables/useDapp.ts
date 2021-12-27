// @ts-ignore
import Web3 from 'web3/dist/web3.min.js'

export function useDapp() {
  const web3 = ref()
  const walletAddress = ref<string>('')
  const chainId = ref<string>('')
  const isConnected = computed(() => {
    return !!walletAddress.value
  })
  const balance = ref(0)

  function getContract(abi: any[]) {
    return new web3.value.eth.Contract(abi)
  }

  watchEffect(async() => {
    console.log('watchEffect', web3, walletAddress.value) // eslint-disable-line no-console
    if (!web3.value || !walletAddress.value)
      return
    const bl = await web3.value.eth.getBalance(walletAddress.value)
    const formatted = await web3.value.utils.fromWei(bl, 'ether')
    balance.value = formatted
  })

  async function connectWallet() {
    const ethereum = (window as any).ethereum
    if (ethereum) {
      await ethereum.send('eth_requestAccounts')
      return true
    }
    return false
  }

  onMounted(() => {
    const ethereum = (window as any).ethereum
    if (!ethereum)
      return

    web3.value = new Web3(ethereum)

    web3.value.eth.getAccounts().then((accounts: string[]) => {
      walletAddress.value = accounts[0]
    })
    web3.value.eth.net.getId().then((id: string) => {
      chainId.value = id
    })

    ethereum.on('accountsChanged', (accounts: string[]) => {
      walletAddress.value = accounts[0]
    })

    // detect Network account change
    ethereum.on('networkChanged', (id: string) => {
      chainId.value = id
    })
  })

  return {
    walletAddress,
    isConnected,
    connectWallet,
    chainId,
    balance,
    getContract,
    web3,
  }
}
