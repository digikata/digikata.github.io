+++
title = "Gov't Blocks Private Testing for Mad Cow Disease"
date = 2008-08-30

[taxonomies]
tags = ["bayesian", "health", "math", "policy"]

[extra]
original_url = "https://digikata.blogspot.com/2008/08/govt-blocks-private-testing-for-mad-cow.html"
+++

I had intended to keep this blog mostly technical, but this just makes me angry.  Creekstone Farms Premium Beef was blocked from performing "mad-cow" tests on 100% of its beef by U.S. Dept. of Agriculture and USDA. This is an issue that affects both free market practice within the the United States and an international competitiveness issue as Creekstone was trying to use the testing to increase its ability to sell its beef to other countries.

The authority to block the testing seems to be granted by a 1913 law allowing the USDA to regulate "treatment" of animals. The court accepts the argument of the government that treatment includes diagnosis and testing. The LegalTimes blog writes:
"There is a two- to eight-year incubation period for mad cow disease. Because most cattle slaughtered in the United States are less than 24 months old, the most common mad cow disease test is unlikely to catch the disease, the appeals court noted. If the government does not control the tests, the USDA is worried about beef exporters unilaterally giving consumers false assurance."

Here's where it gets at least a little technical. Maybe instead of blocking a company wanting to perform additional testing on it's products, the USDA should be advising the company how best to perform its testing. The language implies that there is a more accurate test for the disease - why not require the better test if they are concerned about false assurances. Or design an experimentally robust methodology to maybe hold back a few cows from slaughter to age them to maturity where the disease could be detected. Anything is better than willful ignorance of a fatal disease!

One technical aspect we have to come to grips with here is that in this case is that tests often aren't perfect. It's a wide problem. Almost all medical tests have statistical probabilities in at least four states:
- true positive:  the cow has the disease and the test correctly identifies it

- true negative: the cow is disease free and the test correctly indicates this.

- false positive: the cow is disease free and the test incorrectly indicates that is diseased

- false negative: the cow is diseased and the test incorrectly indicates it's safe

One does have to worry about all the outcomes, especially when testing 100%. Look at Bayesian inference in Wikipedia, particularly the portions relating to [medical testing](http://en.wikipedia.org/wiki/Bayesian_statistics#False_positives_in_a_medical_test). In particular, one needs to look at false positives when the rate of disease is lower then the false-alarm rate - there is a legitimate concern here that tests and followup tests may cost a lot of money, cause a lot of concern , and not increase safety overall.

Overall though, the actions of the government here seem particularly onerous when we lose an opportunity for government to work with a private company that seems willing to implement new approaches to at least characterize the rate of a serious disease.  It also seems like the government values the profits of the beef industry over pushing forward to proactively address a public health concern. If the tests aren't perfect now, we should be able to create policy to handle the real complexities while allowing the free market to bring down costs of safer products.

Imagine if a government agency told one car manufacturer that it couldn't install seat belts and airbags because consumers might demand the additional safety procedures from other car makers. "Volvo, you are barred from putting traction control in your cars because Ford might be put at a disadvantage... "  Shouldn't we be promoting a free market that actively competes on adding customer safety into products!

(From the [Federal appeals court](http://pacer.cadc.uscourts.gov/common/opinions/200808/07-5173-1135720.pdf) via the [LegalTimes](http://legaltimes.typepad.com/blt/2008/08/court-beef-expo.html) blog via [Slashdot](http://news.slashdot.org/article.pl?sid=08/08/30/238223&from=rss))
