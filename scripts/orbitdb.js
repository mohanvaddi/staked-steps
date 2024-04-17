import { createHelia } from 'helia'
import { createOrbitDB, OrbitDBAccessController } from '@orbitdb/core'
import { createLibp2p } from 'libp2p'
import { identify } from '@libp2p/identify'
import { mdns } from '@libp2p/mdns'
import { yamux } from '@chainsafe/libp2p-yamux'
import { tcp } from '@libp2p/tcp'
import { gossipsub } from '@chainsafe/libp2p-gossipsub'
import { noise } from '@chainsafe/libp2p-noise'
import { LevelBlockstore } from 'blockstore-level'

const libp2pOptions = {
  peerDiscovery: [
    mdns()
  ],     
  addresses: {
    listen: [
      '/ip4/0.0.0.0/tcp/0'
    ]
  },
  transports: [
    tcp()
  ],    
  connectionEncryption: [
    noise()
  ],
  streamMuxers: [
    yamux()
  ],
  services: {
    identify: identify(),
    pubsub: gossipsub({ emitSelf: true })
  }
}

const blockstore = new LevelBlockstore(`./db/ipfs/challenges`)

const libp2p = await createLibp2p(libp2pOptions)

const ipfs = await createHelia({ libp2p, blockstore })

const orbitdb = await createOrbitDB({ ipfs, id: 'staked-steps', directory: `./db/orbitdb/challenges` })

const db = await orbitdb.open('challenges', { AccessController: OrbitDBAccessController({ write: ['*'] }), type: "documents" })
console.log(db.address)

db.events.on('update', event => {
  console.log('update', event)
})

process.on('SIGINT', async () => {
  console.log("exiting...")

  await db.close()
  await orbitdb.stop()
  await ipfs.stop()
  process.exit(0)
})