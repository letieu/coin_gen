<script setup lang="ts">
// @ts-ignore
import Web3 from 'web3/dist/web3.min.js'
import { useAbis, useDapp } from '~/composables'

const { walletAddress, isConnected, connectWallet, chainId, balance, getContract } = useDapp()
const { getAbi } = useAbis()

const options = ['Standard', 'Mintable', 'Mintable unlimited', 'Burnable']
const type = ref(options[0])
const error = ref('')
const notification = ref('')

const form = reactive({
  name: '',
  symbol: '',
  decimals: '',
  initialBalance: '',
  cap: '',
})

function getRequiredFields() {
  const requiredFields = ['name', 'symbol', 'decimals', 'initialBalance']
  if (type.value === 'Mintable')
    requiredFields.push('cap')
  return requiredFields
}

function validate(fileds: string[]) {
  const unfilledFields = fileds.find(field => form[field as keyof typeof form] === '')
  if (unfilledFields) {
    error.value = `Please fill in the ${unfilledFields} field`
    return false
  }

  error.value = ''
  return true
}

function submit() {
  notification.value = ''
  const decimals = Web3.utils.toBN(form.decimals)
  const cap = Web3.utils.toBN(form.cap).mul(Web3.utils.toBN(Math.pow(10, +form.decimals)))
  const initialBalance = Web3.utils.toBN(form.initialBalance).mul(Web3.utils.toBN(Math.pow(10, +form.decimals)))
  console.log(decimals, cap, initialBalance) // eslint-disable-line no-console

  const requiredFields = getRequiredFields()
  if (!validate(requiredFields)) return
  const params = [
    form.name,
    form.symbol,
    decimals,
    initialBalance,
  ]
  if (type.value === 'Mintable')
    params.push(cap)

  deploy(type.value, params)
}

async function deploy(type: string, params: string[]) {
  const contractAbi = getAbi(type)
  const contract = getContract(contractAbi.abi)

  try {
    const deployOptions = {
      data: contractAbi.data.bytecode.object,
      arguments: params,
    }

    const sendOptions = {
      from: walletAddress.value,
      gasPrice: '10000000000',
    }

    contract.deploy(deployOptions)
      .send(sendOptions)
      .on('error', (error: any) => {
        console.log(error.message) // eslint-disable-line no-console
      })
      .on('transactionHash', (transactionHash: any) => {
        console.log(transactionHash) // eslint-disable-line no-console
      })
      .on('receipt', (receipt: any) => {
        const tokenAddress = receipt.contractAddress
        console.log(tokenAddress) // eslint-disable-line no-console
        notification.value = `Token address: ${tokenAddress}`
      })
  }
  catch (e: any) {
    console.log(e.message) // eslint-disable-line no-console
  }
}

</script>

<template>
  <section class="container">
    <div class="columns is-multiline">
      <div class="column is-8 is-offset-2 register">
        <div class="columns">
          <div class="column left">
            <h2 class="subtitle colored is-4">Token generator</h2>

            <div class="field" v-if="isConnected">
              <p>
                Wallet connected:
                <span class="colored">{{ walletAddress }}</span>
              </p>
              <p>
                Chain ID:
                <span class="colored">{{ chainId }}</span>
              </p>
              <p>
                Balance:
                <span class="colored">{{ (+balance).toFixed(5) }}</span>
              </p>
            </div>

            <div class="field" v-else>
              <button
                class="button is-block is-primary is-fullwidth is-medium"
                @click.prevent="connectWallet"
              >Connect wallet</button>
            </div>

            <div class="field">
              <label class="label">Protocol</label>
              <div class="control">
                <div class="select">
                  <select>
                    <option>BEP20 (BNB)</option>
                    <option>ERC20 (ETH)</option>
                    <option>MRC20 (Polygon)</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="field">
              <label class="label">Token type</label>
              <div class="control">
                <div class="select">
                  <select v-model="type">
                    <option v-for="option in options" :key="option" :value="option">{{ option }}</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <div class="column right">
            <h1 class="title is-4">Params</h1>
            <div class="notification is-danger" v-if="error">{{ error }}</div>
            <div class="notification is-success" v-if="notification">{{ notification }}</div>

            <form>
              <div class="field">
                <label class="label">Name*</label>
                <div class="control">
                  <input
                    class="input is-medium"
                    type="text"
                    placeholder="ETHER"
                    v-model="form.name"
                  />
                </div>
              </div>

              <div class="field">
                <label class="label">Symbol*</label>
                <div class="control">
                  <input
                    class="input is-medium"
                    type="text"
                    placeholder="ETH"
                    v-model="form.symbol"
                  />
                </div>
              </div>

              <div class="field">
                <label class="label">Decimals*</label>
                <div class="control">
                  <input
                    class="input is-medium"
                    type="number"
                    min="0"
                    max="18"
                    placeholder="18"
                    v-model="form.decimals"
                  />
                </div>
              </div>

              <div class="field">
                <label class="label">Initial Supply*</label>
                <div class="control">
                  <input
                    class="input is-medium"
                    type="number"
                    placeholder="1000"
                    v-model="form.initialBalance"
                  />
                </div>
              </div>

              <div class="field" v-if="['Mintable'].includes(type)">
                <label class="label">Limit Supply*</label>
                <div class="control">
                  <input
                    class="input is-medium"
                    type="number"
                    placeholder="2000"
                    v-model="form.cap"
                  />
                </div>
              </div>

              <button
                class="button is-block is-primary is-fullwidth is-medium"
                @click.prevent="submit"
              >Create token</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style>
:root {
  --brandColor: hsl(166, 67%, 51%);
  --background: rgb(247, 247, 247);
  --textDark: hsla(0, 0%, 0%, 0.66);
  --textLight: hsla(0, 0%, 0%, 0.33);
}

body {
  background: var(--background);
  height: 100vh;
  color: var(--textDark);
}

.field:not(:last-child) {
  margin-bottom: 1rem;
}

.register {
  margin-top: 10rem;
  background: white;
  border-radius: 10px;
}

.left,
.right {
  padding: 4.5rem;
}

.left {
  border-right: 5px solid var(--background);
}

.left .title {
  font-weight: 800;
  letter-spacing: -2px;
}

.left .colored {
  color: var(--brandColor);
  font-weight: 500;
  margin-top: 1rem !important;
  letter-spacing: -1px;
}

.left p {
  color: var(--textLight);
  font-size: 1.15rem;
}

.right .title {
  font-weight: 800;
  letter-spacing: -1px;
}

.right .description {
  margin-top: 1rem;
  margin-bottom: 1rem !important;
  color: var(--textLight);
  font-size: 1.15rem;
}

.right small {
  color: var(--textLight);
}

input {
  font-size: 1rem;
}

input:focus {
  border-color: var(--brandColor) !important;
  box-shadow: 0 0 0 1px var(--brandColor) !important;
}

.fab,
.fas {
  color: var(--textLight);
  margin-right: 1rem;
}
</style>
