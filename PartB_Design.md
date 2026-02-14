# Part B: Design Document

**Section 1: SkillsMarketplace (Agricultural Marketplace)**

**Section 2: SecureLottery (DeFi & NFT Integration)**

---

## WHY I BUILT IT THIS WAY

### 1. Data Structure Choices
**Explain your design decisions for BOTH contracts:**
- When would you choose to use a `mapping` instead of an `array`?
- How did you structure your state variables in `SkillsMarketplace` vs `SecureLottery`?
- What trade-offs did you consider for storage efficiency?

[Write your response here]
Mapping for quick lookup of wrkers and player entries in secureLottery it is good for checking registration and entry counts 
arrays for listing gigs and lttery entries where many entries per address are allowed 
 skilsmarketPlace : workers mapping , gig mapping ,application mapping .
 secure lttery : entries array for total entries ,playerEntryCount mapping . 
tradeoffs
mapping cannot iterate 
array easy iteration but costly for huge data .
---

### 2. Security Measures
**What attacks did you protect against in BOTH implementations?**
- Reentrancy attacks? (Explain your implementation of the Checks-Effects-Interactions pattern)
- Access control vulnerabilities?
- Integer overflow/underflow?
- Front-running/Randomness manipulation (specifically for `SecureLottery`)?

[Write your response here]
For SkillsMarket  postGig and approvaAndPay are the most expensive because of storage wrrites and ETH transfar .
SecureLotter selctWinner could be costly because of larger number of entries 

---

### 3. Trade-offs & Future Improvements
**What would you change with more time?**
- Gas optimization opportunities?
- Additional features (e.g., dispute resolution, multiple prize tiers)?
- Better error handling?

[Write your response here]

Use storage not memory 
multiple prize tiers in lotter 
custom errors can minize gas .

## REAL-WORLD DEPLOYMENT CONCERNS

### 1. Gas Costs
**Analyze the viability of your contracts for real-world use:**
- Estimated gas for key functions (e.g., `postGig`, `selectWinner`).
- Is this viable for users in constrained environments (e.g., high gas fees)?
- Any specific optimization strategies you implemented?

[Write your response here]

---   PostGig and slcteinner are expensive loops to use .
storage can get bigger as arrays get bigger 
try offchain randomness 


### 2. Scalability
**What happens with 10,000+ entries/gigs?**
- Performance considerations for loops or large arrays.
- Storage cost implications.
- Potential bottlenecks in `selectWinner` or `applyForGig`.

[Write your response here]

--- 10 000 entries 
Loops in application will be expensive 
winner selection if array is  huge 

### User Experience

**How would you make this usable for non-crypto users?**
- Onboarding process?
- MetaMask alternatives?
- Mobile accessibility?

[Write about your UX(user experience) considerations]

---

## MY LEARNING APPROACH

### Resources I Used

**Show self-directed learning:**
- Documentation consulted
- Tutorials followed
- Community resources

[List 3-5 resources you used]

---

### Challenges Faced

**Problem-solving evidence:**
- Biggest technical challenge
- How you solved it
- What you learned

[Write down your challenges]

---

### What I'd Learn Next

**Growth mindset indicator:**
- Advanced Solidity patterns
- Testing frameworks
- Frontend integration

[Write your future learning goals]

---
