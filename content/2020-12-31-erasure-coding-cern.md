+++
title = "Paper: Erasure Coding for production in the EOS Open Storage system"
date = 2020-12-04
+++

A paper on use of per-file Erasure Coding redundancy in the EOS Filesystem used at CERN. Reasonably basic use of EC at this level of description, but it is always nice to see a review of various design decisons in a real world system.

Abstract, comments and links further on.

<!-- more -->

**Abstract** The storage group of CERN IT operates more than 20 individualEOS storage services with a raw data storage volume of more than 340 PB.Storage space is a major cost factor in HEP computing and the planned futureLHC Run 3 and 4 increase storage space demands by at least an order of mag-nitude.A cost effective storage model providing durability is Erasure Coding (EC). The decommissioning of CERN’s remote computer center (Wigner/Budapest) allows a reconsideration of the currently configured dual-replica strategy where EOS provides one replica in each computer center. EOS allows one to configure EC on a per file bases and exposes four differentredundancy levels with single, dual, triple and fourfold parity to select differentquality of service and variable costs.This paper will highlight tests which have been performed to migrate files ona production instance from dual-replica to various EC profiles. It will discuss performance and operational impact, and highlight various policy scenarios toselect the best file layout with respect to IO patterns, file age and file size.We will conclude with the current status and future optimizations, an evaluationof cost savings and discuss an erasure encoded EOS setup as a possible tapestorage replacement

Also included some discussion of conversion and anticipated performance due to
the EC storage design decisions.

Conference [link](https://www.epj-conferences.org/articles/epjconf/abs/2020/21/epjconf_chep2020_04008/epjconf_chep2020_04008.html)

Direct paper [link](https://www.epj-conferences.org/articles/epjconf/pdf/2020/21/epjconf_chep2020_04008.pdf)






