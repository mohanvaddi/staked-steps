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

const id = "challenges";
const dbAddress = process.env.ORBIT_DB_ADDRESS;

const blockstore = new LevelBlockstore(`../../ipfs/${id}`)
const libp2p = await createLibp2p(libp2pOptions)
const ipfs = await createHelia({ libp2p, blockstore })
const orbitdb = await createOrbitDB({ ipfs, id: `${id}`, directory: `../../orbitdb/${id}` })

const db = await orbitdb.open(dbAddress, { type: "documents"})

// Example doc: { _id: "eth24", msg: "Scaling Hackathon", views: 10, teams:2 }
export const saveDoc = async (doc) => {
  await db.put(doc);
}

// Example _id "eth24"
export const deleteDoc = async(_id) => {
  await db.del(_id);
}

// Example _id "eth24"
export const getDoc = async (_id) => {
  const doc = await db.get(_id);
  return doc.value;
}

// Example queryFn
// const findFn = (doc) => doc.views > 5 && doc.teams > 1;
export const getDocs = async(queryFn) => {
  let docs;
  if (!queryFn) {
    docs = await db.all();
  } else {
    docs = await db.query(queryFn);
  }
  return docs.map(doc=> doc.value);
}
