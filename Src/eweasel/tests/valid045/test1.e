
--| Copyright (c) 1993-2006 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.

class TEST1 [X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, X16, X17, X18, X19, X20, X21, X22, X23, X24, X25, X26, X27, X28, X29, X30, X31, X32, X33, X34, X35, X36, X37, X38, X39, X40, X41, X42, X43, X44, X45, X46, X47, X48, X49, X50, X51, X52, X53, X54, X55, X56, X57, X58, X59, X60, X61, X62, X63, X64, X65, X66, X67, X68, X69, X70, X71, X72, X73, X74, X75, X76, X77, X78, X79, X80, X81, X82, X83, X84, X85, X86, X87, X88, X89, X90, X91, X92, X93, X94, X95, X96, X97, X98, X99, X100, X101, X102, X103, X104, X105, X106, X107, X108, X109, X110, X111, X112, X113, X114, X115, X116, X117, X118, X119, X120, X121, X122, X123, X124, X125, X126, X127, X128, X129, X130, X131, X132, X133, X134, X135, X136, X137, X138, X139, X140, X141, X142, X143, X144, X145, X146, X147, X148, X149, X150, X151, X152, X153, X154, X155, X156, X157, X158, X159, X160, X161, X162, X163, X164, X165, X166, X167, X168, X169, X170, X171, X172, X173, X174, X175, X176, X177, X178, X179, X180, X181, X182, X183, X184, X185, X186, X187, X188, X189, X190, X191, X192, X193, X194, X195, X196, X197, X198, X199, X200, X201, X202, X203, X204, X205, X206, X207, X208, X209, X210, X211, X212, X213, X214, X215, X216, X217, X218, X219, X220, X221, X222, X223, X224, X225, X226, X227, X228, X229, X230, X231, X232, X233, X234, X235, X236, X237, X238, X239, X240, X241, X242, X243, X244, X245, X246, X247, X248, X249, X250, X251, X252, X253, X254, X255, X256, X257, X258, X259, X260, X261, X262, X263, X264, X265, X266, X267, X268, X269, X270, X271, X272, X273, X274, X275, X276, X277, X278, X279, X280, X281, X282, X283, X284, X285, X286, X287, X288, X289, X290, X291, X292, X293, X294, X295, X296, X297, X298, X299, X300, X301, X302, X303, X304, X305, X306, X307, X308, X309, X310, X311, X312, X313, X314, X315, X316, X317, X318, X319, X320, X321, X322, X323, X324, X325, X326, X327, X328, X329, X330, X331, X332, X333, X334, X335, X336, X337, X338, X339, X340, X341, X342, X343, X344, X345, X346, X347, X348, X349, X350, X351, X352, X353, X354, X355, X356, X357, X358, X359, X360, X361, X362, X363, X364, X365, X366, X367, X368, X369, X370, X371, X372, X373, X374, X375, X376, X377, X378, X379, X380, X381, X382, X383, X384, X385, X386, X387, X388, X389, X390, X391, X392, X393, X394, X395, X396, X397, X398, X399, X400, X401, X402, X403, X404, X405, X406, X407, X408, X409, X410, X411, X412, X413, X414, X415, X416, X417, X418, X419, X420, X421, X422, X423, X424, X425, X426, X427, X428, X429, X430, X431, X432, X433, X434, X435, X436, X437, X438, X439, X440, X441, X442, X443, X444, X445, X446, X447, X448, X449, X450, X451, X452, X453, X454, X455, X456, X457, X458, X459, X460, X461, X462, X463, X464, X465, X466, X467, X468, X469, X470, X471, X472, X473, X474, X475, X476, X477, X478, X479, X480, X481, X482, X483, X484, X485, X486, X487, X488, X489, X490, X491, X492, X493, X494, X495, X496, X497, X498, X499, X500, X501, X502, X503, X504, X505, X506, X507, X508, X509, X510, X511, X512, X513, X514, X515, X516, X517, X518, X519, X520, X521, X522, X523, X524, X525, X526, X527, X528, X529, X530, X531, X532, X533, X534, X535, X536, X537, X538, X539, X540, X541, X542, X543, X544, X545, X546, X547, X548, X549, X550, X551, X552, X553, X554, X555, X556, X557, X558, X559, X560, X561, X562, X563, X564, X565, X566, X567, X568, X569, X570, X571, X572, X573, X574, X575, X576, X577, X578, X579, X580, X581, X582, X583, X584, X585, X586, X587, X588, X589, X590, X591, X592, X593, X594, X595, X596, X597, X598, X599, X600, X601, X602, X603, X604, X605, X606, X607, X608, X609, X610, X611, X612, X613, X614, X615, X616, X617, X618, X619, X620, X621, X622, X623, X624, X625, X626, X627, X628, X629, X630, X631, X632, X633, X634, X635, X636, X637, X638, X639, X640, X641, X642, X643, X644, X645, X646, X647, X648, X649, X650, X651, X652, X653, X654, X655, X656, X657, X658, X659, X660, X661, X662, X663, X664, X665, X666, X667, X668, X669, X670, X671, X672, X673, X674, X675, X676, X677, X678, X679, X680, X681, X682, X683, X684, X685, X686, X687, X688, X689, X690, X691, X692, X693, X694, X695, X696, X697, X698, X699, X700, X701, X702, X703, X704, X705, X706, X707, X708, X709, X710, X711, X712, X713, X714, X715, X716, X717, X718, X719, X720, X721, X722, X723, X724, X725, X726, X727, X728, X729, X730, X731, X732, X733, X734, X735, X736, X737, X738, X739, X740, X741, X742, X743, X744, X745, X746, X747, X748, X749, X750, X751, X752, X753, X754, X755, X756, X757, X758, X759, X760, X761, X762, X763, X764, X765, X766, X767, X768, X769, X770, X771, X772, X773, X774, X775, X776, X777, X778, X779, X780, X781, X782, X783, X784, X785, X786, X787, X788, X789, X790, X791, X792, X793, X794, X795, X796, X797, X798, X799, X800, X801, X802, X803, X804, X805, X806, X807, X808, X809, X810, X811, X812, X813, X814, X815, X816, X817, X818, X819, X820, X821, X822, X823, X824, X825, X826, X827, X828, X829, X830, X831, X832, X833, X834, X835, X836, X837, X838, X839, X840, X841, X842, X843, X844, X845, X846, X847, X848, X849, X850, X851, X852, X853, X854, X855, X856, X857, X858, X859, X860, X861, X862, X863, X864, X865, X866, X867, X868, X869, X870, X871, X872, X873, X874, X875, X876, X877, X878, X879, X880, X881, X882, X883, X884, X885, X886, X887, X888, X889, X890, X891, X892, X893, X894, X895, X896, X897, X898, X899, X900, X901, X902, X903, X904, X905, X906, X907, X908, X909, X910, X911, X912, X913, X914, X915, X916, X917, X918, X919, X920, X921, X922, X923, X924, X925, X926, X927, X928, X929, X930, X931, X932, X933, X934, X935, X936, X937, X938, X939, X940, X941, X942, X943, X944, X945, X946, X947, X948, X949, X950, X951, X952, X953, X954, X955, X956, X957, X958, X959, X960, X961, X962, X963, X964, X965, X966, X967, X968, X969, X970, X971, X972, X973, X974, X975, X976, X977, X978, X979, X980, X981, X982, X983, X984, X985, X986, X987, X988, X989, X990, X991, X992, X993, X994, X995, X996, X997, X998, X999, X1000]
feature
	x1: X1
	x2: X2
	x3: X3
	x4: X4
	x5: X5
	x6: X6
	x7: X7
	x8: X8
	x9: X9
	x10: X10
	x11: X11
	x12: X12
	x13: X13
	x14: X14
	x15: X15
	x16: X16
	x17: X17
	x18: X18
	x19: X19
	x20: X20
	x21: X21
	x22: X22
	x23: X23
	x24: X24
	x25: X25
	x26: X26
	x27: X27
	x28: X28
	x29: X29
	x30: X30
	x31: X31
	x32: X32
	x33: X33
	x34: X34
	x35: X35
	x36: X36
	x37: X37
	x38: X38
	x39: X39
	x40: X40
	x41: X41
	x42: X42
	x43: X43
	x44: X44
	x45: X45
	x46: X46
	x47: X47
	x48: X48
	x49: X49
	x50: X50
	x51: X51
	x52: X52
	x53: X53
	x54: X54
	x55: X55
	x56: X56
	x57: X57
	x58: X58
	x59: X59
	x60: X60
	x61: X61
	x62: X62
	x63: X63
	x64: X64
	x65: X65
	x66: X66
	x67: X67
	x68: X68
	x69: X69
	x70: X70
	x71: X71
	x72: X72
	x73: X73
	x74: X74
	x75: X75
	x76: X76
	x77: X77
	x78: X78
	x79: X79
	x80: X80
	x81: X81
	x82: X82
	x83: X83
	x84: X84
	x85: X85
	x86: X86
	x87: X87
	x88: X88
	x89: X89
	x90: X90
	x91: X91
	x92: X92
	x93: X93
	x94: X94
	x95: X95
	x96: X96
	x97: X97
	x98: X98
	x99: X99
	x100: X100
	x101: X101
	x102: X102
	x103: X103
	x104: X104
	x105: X105
	x106: X106
	x107: X107
	x108: X108
	x109: X109
	x110: X110
	x111: X111
	x112: X112
	x113: X113
	x114: X114
	x115: X115
	x116: X116
	x117: X117
	x118: X118
	x119: X119
	x120: X120
	x121: X121
	x122: X122
	x123: X123
	x124: X124
	x125: X125
	x126: X126
	x127: X127
	x128: X128
	x129: X129
	x130: X130
	x131: X131
	x132: X132
	x133: X133
	x134: X134
	x135: X135
	x136: X136
	x137: X137
	x138: X138
	x139: X139
	x140: X140
	x141: X141
	x142: X142
	x143: X143
	x144: X144
	x145: X145
	x146: X146
	x147: X147
	x148: X148
	x149: X149
	x150: X150
	x151: X151
	x152: X152
	x153: X153
	x154: X154
	x155: X155
	x156: X156
	x157: X157
	x158: X158
	x159: X159
	x160: X160
	x161: X161
	x162: X162
	x163: X163
	x164: X164
	x165: X165
	x166: X166
	x167: X167
	x168: X168
	x169: X169
	x170: X170
	x171: X171
	x172: X172
	x173: X173
	x174: X174
	x175: X175
	x176: X176
	x177: X177
	x178: X178
	x179: X179
	x180: X180
	x181: X181
	x182: X182
	x183: X183
	x184: X184
	x185: X185
	x186: X186
	x187: X187
	x188: X188
	x189: X189
	x190: X190
	x191: X191
	x192: X192
	x193: X193
	x194: X194
	x195: X195
	x196: X196
	x197: X197
	x198: X198
	x199: X199
	x200: X200
	x201: X201
	x202: X202
	x203: X203
	x204: X204
	x205: X205
	x206: X206
	x207: X207
	x208: X208
	x209: X209
	x210: X210
	x211: X211
	x212: X212
	x213: X213
	x214: X214
	x215: X215
	x216: X216
	x217: X217
	x218: X218
	x219: X219
	x220: X220
	x221: X221
	x222: X222
	x223: X223
	x224: X224
	x225: X225
	x226: X226
	x227: X227
	x228: X228
	x229: X229
	x230: X230
	x231: X231
	x232: X232
	x233: X233
	x234: X234
	x235: X235
	x236: X236
	x237: X237
	x238: X238
	x239: X239
	x240: X240
	x241: X241
	x242: X242
	x243: X243
	x244: X244
	x245: X245
	x246: X246
	x247: X247
	x248: X248
	x249: X249
	x250: X250
	x251: X251
	x252: X252
	x253: X253
	x254: X254
	x255: X255
	x256: X256
	x257: X257
	x258: X258
	x259: X259
	x260: X260
	x261: X261
	x262: X262
	x263: X263
	x264: X264
	x265: X265
	x266: X266
	x267: X267
	x268: X268
	x269: X269
	x270: X270
	x271: X271
	x272: X272
	x273: X273
	x274: X274
	x275: X275
	x276: X276
	x277: X277
	x278: X278
	x279: X279
	x280: X280
	x281: X281
	x282: X282
	x283: X283
	x284: X284
	x285: X285
	x286: X286
	x287: X287
	x288: X288
	x289: X289
	x290: X290
	x291: X291
	x292: X292
	x293: X293
	x294: X294
	x295: X295
	x296: X296
	x297: X297
	x298: X298
	x299: X299
	x300: X300
	x301: X301
	x302: X302
	x303: X303
	x304: X304
	x305: X305
	x306: X306
	x307: X307
	x308: X308
	x309: X309
	x310: X310
	x311: X311
	x312: X312
	x313: X313
	x314: X314
	x315: X315
	x316: X316
	x317: X317
	x318: X318
	x319: X319
	x320: X320
	x321: X321
	x322: X322
	x323: X323
	x324: X324
	x325: X325
	x326: X326
	x327: X327
	x328: X328
	x329: X329
	x330: X330
	x331: X331
	x332: X332
	x333: X333
	x334: X334
	x335: X335
	x336: X336
	x337: X337
	x338: X338
	x339: X339
	x340: X340
	x341: X341
	x342: X342
	x343: X343
	x344: X344
	x345: X345
	x346: X346
	x347: X347
	x348: X348
	x349: X349
	x350: X350
	x351: X351
	x352: X352
	x353: X353
	x354: X354
	x355: X355
	x356: X356
	x357: X357
	x358: X358
	x359: X359
	x360: X360
	x361: X361
	x362: X362
	x363: X363
	x364: X364
	x365: X365
	x366: X366
	x367: X367
	x368: X368
	x369: X369
	x370: X370
	x371: X371
	x372: X372
	x373: X373
	x374: X374
	x375: X375
	x376: X376
	x377: X377
	x378: X378
	x379: X379
	x380: X380
	x381: X381
	x382: X382
	x383: X383
	x384: X384
	x385: X385
	x386: X386
	x387: X387
	x388: X388
	x389: X389
	x390: X390
	x391: X391
	x392: X392
	x393: X393
	x394: X394
	x395: X395
	x396: X396
	x397: X397
	x398: X398
	x399: X399
	x400: X400
	x401: X401
	x402: X402
	x403: X403
	x404: X404
	x405: X405
	x406: X406
	x407: X407
	x408: X408
	x409: X409
	x410: X410
	x411: X411
	x412: X412
	x413: X413
	x414: X414
	x415: X415
	x416: X416
	x417: X417
	x418: X418
	x419: X419
	x420: X420
	x421: X421
	x422: X422
	x423: X423
	x424: X424
	x425: X425
	x426: X426
	x427: X427
	x428: X428
	x429: X429
	x430: X430
	x431: X431
	x432: X432
	x433: X433
	x434: X434
	x435: X435
	x436: X436
	x437: X437
	x438: X438
	x439: X439
	x440: X440
	x441: X441
	x442: X442
	x443: X443
	x444: X444
	x445: X445
	x446: X446
	x447: X447
	x448: X448
	x449: X449
	x450: X450
	x451: X451
	x452: X452
	x453: X453
	x454: X454
	x455: X455
	x456: X456
	x457: X457
	x458: X458
	x459: X459
	x460: X460
	x461: X461
	x462: X462
	x463: X463
	x464: X464
	x465: X465
	x466: X466
	x467: X467
	x468: X468
	x469: X469
	x470: X470
	x471: X471
	x472: X472
	x473: X473
	x474: X474
	x475: X475
	x476: X476
	x477: X477
	x478: X478
	x479: X479
	x480: X480
	x481: X481
	x482: X482
	x483: X483
	x484: X484
	x485: X485
	x486: X486
	x487: X487
	x488: X488
	x489: X489
	x490: X490
	x491: X491
	x492: X492
	x493: X493
	x494: X494
	x495: X495
	x496: X496
	x497: X497
	x498: X498
	x499: X499
	x500: X500
	x501: X501
	x502: X502
	x503: X503
	x504: X504
	x505: X505
	x506: X506
	x507: X507
	x508: X508
	x509: X509
	x510: X510
	x511: X511
	x512: X512
	x513: X513
	x514: X514
	x515: X515
	x516: X516
	x517: X517
	x518: X518
	x519: X519
	x520: X520
	x521: X521
	x522: X522
	x523: X523
	x524: X524
	x525: X525
	x526: X526
	x527: X527
	x528: X528
	x529: X529
	x530: X530
	x531: X531
	x532: X532
	x533: X533
	x534: X534
	x535: X535
	x536: X536
	x537: X537
	x538: X538
	x539: X539
	x540: X540
	x541: X541
	x542: X542
	x543: X543
	x544: X544
	x545: X545
	x546: X546
	x547: X547
	x548: X548
	x549: X549
	x550: X550
	x551: X551
	x552: X552
	x553: X553
	x554: X554
	x555: X555
	x556: X556
	x557: X557
	x558: X558
	x559: X559
	x560: X560
	x561: X561
	x562: X562
	x563: X563
	x564: X564
	x565: X565
	x566: X566
	x567: X567
	x568: X568
	x569: X569
	x570: X570
	x571: X571
	x572: X572
	x573: X573
	x574: X574
	x575: X575
	x576: X576
	x577: X577
	x578: X578
	x579: X579
	x580: X580
	x581: X581
	x582: X582
	x583: X583
	x584: X584
	x585: X585
	x586: X586
	x587: X587
	x588: X588
	x589: X589
	x590: X590
	x591: X591
	x592: X592
	x593: X593
	x594: X594
	x595: X595
	x596: X596
	x597: X597
	x598: X598
	x599: X599
	x600: X600
	x601: X601
	x602: X602
	x603: X603
	x604: X604
	x605: X605
	x606: X606
	x607: X607
	x608: X608
	x609: X609
	x610: X610
	x611: X611
	x612: X612
	x613: X613
	x614: X614
	x615: X615
	x616: X616
	x617: X617
	x618: X618
	x619: X619
	x620: X620
	x621: X621
	x622: X622
	x623: X623
	x624: X624
	x625: X625
	x626: X626
	x627: X627
	x628: X628
	x629: X629
	x630: X630
	x631: X631
	x632: X632
	x633: X633
	x634: X634
	x635: X635
	x636: X636
	x637: X637
	x638: X638
	x639: X639
	x640: X640
	x641: X641
	x642: X642
	x643: X643
	x644: X644
	x645: X645
	x646: X646
	x647: X647
	x648: X648
	x649: X649
	x650: X650
	x651: X651
	x652: X652
	x653: X653
	x654: X654
	x655: X655
	x656: X656
	x657: X657
	x658: X658
	x659: X659
	x660: X660
	x661: X661
	x662: X662
	x663: X663
	x664: X664
	x665: X665
	x666: X666
	x667: X667
	x668: X668
	x669: X669
	x670: X670
	x671: X671
	x672: X672
	x673: X673
	x674: X674
	x675: X675
	x676: X676
	x677: X677
	x678: X678
	x679: X679
	x680: X680
	x681: X681
	x682: X682
	x683: X683
	x684: X684
	x685: X685
	x686: X686
	x687: X687
	x688: X688
	x689: X689
	x690: X690
	x691: X691
	x692: X692
	x693: X693
	x694: X694
	x695: X695
	x696: X696
	x697: X697
	x698: X698
	x699: X699
	x700: X700
	x701: X701
	x702: X702
	x703: X703
	x704: X704
	x705: X705
	x706: X706
	x707: X707
	x708: X708
	x709: X709
	x710: X710
	x711: X711
	x712: X712
	x713: X713
	x714: X714
	x715: X715
	x716: X716
	x717: X717
	x718: X718
	x719: X719
	x720: X720
	x721: X721
	x722: X722
	x723: X723
	x724: X724
	x725: X725
	x726: X726
	x727: X727
	x728: X728
	x729: X729
	x730: X730
	x731: X731
	x732: X732
	x733: X733
	x734: X734
	x735: X735
	x736: X736
	x737: X737
	x738: X738
	x739: X739
	x740: X740
	x741: X741
	x742: X742
	x743: X743
	x744: X744
	x745: X745
	x746: X746
	x747: X747
	x748: X748
	x749: X749
	x750: X750
	x751: X751
	x752: X752
	x753: X753
	x754: X754
	x755: X755
	x756: X756
	x757: X757
	x758: X758
	x759: X759
	x760: X760
	x761: X761
	x762: X762
	x763: X763
	x764: X764
	x765: X765
	x766: X766
	x767: X767
	x768: X768
	x769: X769
	x770: X770
	x771: X771
	x772: X772
	x773: X773
	x774: X774
	x775: X775
	x776: X776
	x777: X777
	x778: X778
	x779: X779
	x780: X780
	x781: X781
	x782: X782
	x783: X783
	x784: X784
	x785: X785
	x786: X786
	x787: X787
	x788: X788
	x789: X789
	x790: X790
	x791: X791
	x792: X792
	x793: X793
	x794: X794
	x795: X795
	x796: X796
	x797: X797
	x798: X798
	x799: X799
	x800: X800
	x801: X801
	x802: X802
	x803: X803
	x804: X804
	x805: X805
	x806: X806
	x807: X807
	x808: X808
	x809: X809
	x810: X810
	x811: X811
	x812: X812
	x813: X813
	x814: X814
	x815: X815
	x816: X816
	x817: X817
	x818: X818
	x819: X819
	x820: X820
	x821: X821
	x822: X822
	x823: X823
	x824: X824
	x825: X825
	x826: X826
	x827: X827
	x828: X828
	x829: X829
	x830: X830
	x831: X831
	x832: X832
	x833: X833
	x834: X834
	x835: X835
	x836: X836
	x837: X837
	x838: X838
	x839: X839
	x840: X840
	x841: X841
	x842: X842
	x843: X843
	x844: X844
	x845: X845
	x846: X846
	x847: X847
	x848: X848
	x849: X849
	x850: X850
	x851: X851
	x852: X852
	x853: X853
	x854: X854
	x855: X855
	x856: X856
	x857: X857
	x858: X858
	x859: X859
	x860: X860
	x861: X861
	x862: X862
	x863: X863
	x864: X864
	x865: X865
	x866: X866
	x867: X867
	x868: X868
	x869: X869
	x870: X870
	x871: X871
	x872: X872
	x873: X873
	x874: X874
	x875: X875
	x876: X876
	x877: X877
	x878: X878
	x879: X879
	x880: X880
	x881: X881
	x882: X882
	x883: X883
	x884: X884
	x885: X885
	x886: X886
	x887: X887
	x888: X888
	x889: X889
	x890: X890
	x891: X891
	x892: X892
	x893: X893
	x894: X894
	x895: X895
	x896: X896
	x897: X897
	x898: X898
	x899: X899
	x900: X900
	x901: X901
	x902: X902
	x903: X903
	x904: X904
	x905: X905
	x906: X906
	x907: X907
	x908: X908
	x909: X909
	x910: X910
	x911: X911
	x912: X912
	x913: X913
	x914: X914
	x915: X915
	x916: X916
	x917: X917
	x918: X918
	x919: X919
	x920: X920
	x921: X921
	x922: X922
	x923: X923
	x924: X924
	x925: X925
	x926: X926
	x927: X927
	x928: X928
	x929: X929
	x930: X930
	x931: X931
	x932: X932
	x933: X933
	x934: X934
	x935: X935
	x936: X936
	x937: X937
	x938: X938
	x939: X939
	x940: X940
	x941: X941
	x942: X942
	x943: X943
	x944: X944
	x945: X945
	x946: X946
	x947: X947
	x948: X948
	x949: X949
	x950: X950
	x951: X951
	x952: X952
	x953: X953
	x954: X954
	x955: X955
	x956: X956
	x957: X957
	x958: X958
	x959: X959
	x960: X960
	x961: X961
	x962: X962
	x963: X963
	x964: X964
	x965: X965
	x966: X966
	x967: X967
	x968: X968
	x969: X969
	x970: X970
	x971: X971
	x972: X972
	x973: X973
	x974: X974
	x975: X975
	x976: X976
	x977: X977
	x978: X978
	x979: X979
	x980: X980
	x981: X981
	x982: X982
	x983: X983
	x984: X984
	x985: X985
	x986: X986
	x987: X987
	x988: X988
	x989: X989
	x990: X990
	x991: X991
	x992: X992
	x993: X993
	x994: X994
	x995: X995
	x996: X996
	x997: X997
	x998: X998
	x999: X999
	x1000: X1000

end
