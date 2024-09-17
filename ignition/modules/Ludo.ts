import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LockModule = buildModule("LudoModule", (m) => {
 
  const ludo = m.contract("Ludo");

  return { ludo };
});

export default LockModule;
