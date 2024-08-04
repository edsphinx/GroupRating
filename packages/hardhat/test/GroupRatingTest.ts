import { expect } from "chai";
import { ethers } from "hardhat";
import { GroupRating } from "../typechain-types";

describe("GroupRating", function () {
  let groupRating: GroupRating;
  let owner: any;
  let addr1: any;
  let addr2: any;
  let addr3: any;

  before(async () => {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    const GroupRatingFactory = await ethers.getContractFactory("GroupRating");
    groupRating = (await GroupRatingFactory.deploy(
      owner.address,
      "0x6d31aea5da7ef46bfaf9b2842fd5013fb1db5a46a24c855b361dbdee1f855573",
    )) as GroupRating;
    await groupRating.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await groupRating.owner()).to.equal(owner.address);
    });

    it("Should set the schemaID", async function () {
      expect(await groupRating.schemaID()).to.equal(
        "0x6d31aea5da7ef46bfaf9b2842fd5013fb1db5a46a24c855b361dbdee1f855573",
      );
    });
  });

  // describe("Team Management", function () {
  //   it("Should create a team and add members", async function () {
  //     await groupRating.createTeam([addr1.address, addr2.address]);
  //     const teamsAddr1 = await groupRating.getTeamsByAddress(addr1.address);
  //     const teamsAddr2 = await groupRating.getTeamsByAddress(addr2.address);
  //     expect(teamsAddr1.length).to.equal(1);
  //     expect(teamsAddr2.length).to.equal(1);

  //     await groupRating.addMember(1, addr3.address);
  //     const teamsAddr3 = await groupRating.getTeamsByAddress(addr3.address);
  //     expect(teamsAddr3.length).to.equal(1);
  //   });

  //   it("Should get the total teams", async function () {
  //     await groupRating.createTeam([addr1.address, addr2.address]);
  //     await groupRating.createTeam([addr3.address]);
  //     const totalTeams = await groupRating.getTotalTeams();
  //     expect(totalTeams.length).to.equal(2);
  //   });
  // });

  describe("Rating System", function () {
    it("Should allow team members to assign ratings", async function () {
      await groupRating.createTeam([addr1.address, addr2.address]);
      await groupRating.connect(addr1).assignRate(1, addr2.address, 5, "Great work!");

      const counter = await groupRating.userCounter(addr2.address, 1);
      expect(counter).to.equal(5);
    });

    it("Should revert if a non-team member tries to assign ratings", async function () {
      await groupRating.createTeam([addr1.address, addr2.address]);

      await expect(
        groupRating.connect(addr3).assignRate(1, addr2.address, 5, "Great work!"),
      ).to.be.revertedWithCustomError(groupRating, "OnlyTeamMember");
    });
  });

  // describe("Grant Distribution", function () {
  //   it("Should distribute grant based on ratings", async function () {
  //     await groupRating.createTeam([addr1.address, addr2.address, addr3.address]);
  //     await groupRating.connect(addr1).assignRate(1, addr2.address, 5, "Great work!");
  //     await groupRating.connect(addr1).assignRate(1, addr3.address, 10, "Excellent!");

  //     const initialBalanceAddr2 = await ethers.provider.getBalance(addr2.address);
  //     const initialBalanceAddr3 = await ethers.provider.getBalance(addr3.address);

  //     await groupRating.connect(owner).distributeGrant(1, ethers.utils.parseEther("1.0"));

  //     const finalBalanceAddr2 = await ethers.provider.getBalance(addr2.address);
  //     const finalBalanceAddr3 = await ethers.provider.getBalance(addr3.address);

  //     const differenceAddr2 = finalBalanceAddr2 - initialBalanceAddr2;
  //     const differenceAddr3 = finalBalanceAddr3 - initialBalanceAddr3;

  //     expect(differenceAddr2).to.be.closeTo(ethers.utils.parseEther("0.333"), ethers.utils.parseEther("0.001"));
  //     expect(differenceAddr3).to.be.closeTo(ethers.utils.parseEther("0.666"), ethers.utils.parseEther("0.001"));
  //   });
  // });
});
