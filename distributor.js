
import { ethers } from "ethers";

export async function runDistribution(contract, holders) {
    const tx = await contract.executeDistribution(holders);
    await tx.wait();
}
