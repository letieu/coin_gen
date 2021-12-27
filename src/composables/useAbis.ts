import StandardBEP20 from '../contracts/token/BEP20/artifacts/StandardBEP20.json'
import MintableBEP20 from '../contracts/token/BEP20/artifacts/MintableBEP20.json'
import BurnableBEP20 from '../contracts/token/BEP20/artifacts/BurnableBEP20.json'
import UnlimitedBEP20 from '../contracts/token/BEP20/artifacts/UnlimitedBEP20.json'

export function useAbis() {
  function getAbi(type: string) {
    switch (type) {
      case 'Standard':
        return StandardBEP20
      case 'Mintable':
        return MintableBEP20
      case 'Mintable unlimited':
        return UnlimitedBEP20
      case 'Burnable':
        return BurnableBEP20
      default:
        return StandardBEP20
    }
  }
  return { getAbi }
}
