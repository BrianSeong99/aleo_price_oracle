program aleooracle.aleo;

struct OraclePrice:
    price_key as u64;
    price as u64;
    decimal as u8;
    height as u32;

struct OraclePriceDataEntry:
    null as boolean;
    sig as signature;
    a as address;
    oracle_price as OraclePrice;

struct PriceEntry:
    price as u64;
    decimal as u8;


mapping price_quote:
	key as u64.public;
	value as PriceEntry.public;

closure data_checker:
    input r0 as OraclePriceDataEntry;
    input r1 as u64;
    input r2 as u8;
    input r3 as u32;
    assert.eq r0.oracle_price.price_key r1;
    assert.eq r0.oracle_price.decimal r2;
    assert.eq r0.oracle_price.height r3;


function price_aggregator:
    input r0 as u64.private;
    input r1 as u8.private;
    input r2 as u32.private;
    input r3 as [OraclePriceDataEntry; 8u32].private;
    input r4 as u64.private;
    input r5 as u64.private;
    call data_checker r3[0u32] r0 r1 r2;
    add r3[0u32].oracle_price.price_key r3[0u32].oracle_price.price into r6;
    cast r3[0u32].oracle_price.height into r7 as u64;
    add r6 r7 into r8;
    sign.verify r3[0u32].sig r3[0u32].a r8 into r9;
    sign.verify r3[0u32].sig r3[0u32].a r8 into r10;
    is.eq r9 r10 into r11;
    is.eq r3[0u32].null true into r12;
    is.eq r11 r12 into r13;
    add 0u64 r3[0u32].oracle_price.price into r14;
    ternary r13 r14 0u64 into r15;
    add 0u8 1u8 into r16;
    ternary r13 r16 0u8 into r17;
    call data_checker r3[1u32] r0 r1 r2;
    add r3[1u32].oracle_price.price_key r3[1u32].oracle_price.price into r18;
    cast r3[1u32].oracle_price.height into r19 as u64;
    add r18 r19 into r20;
    sign.verify r3[1u32].sig r3[1u32].a r20 into r21;
    sign.verify r3[1u32].sig r3[1u32].a r20 into r22;
    is.eq r21 r22 into r23;
    is.eq r3[1u32].null true into r24;
    is.eq r23 r24 into r25;
    add r15 r3[1u32].oracle_price.price into r26;
    ternary r25 r26 r15 into r27;
    add r17 1u8 into r28;
    ternary r25 r28 r17 into r29;
    call data_checker r3[2u32] r0 r1 r2;
    add r3[2u32].oracle_price.price_key r3[2u32].oracle_price.price into r30;
    cast r3[2u32].oracle_price.height into r31 as u64;
    add r30 r31 into r32;
    sign.verify r3[2u32].sig r3[2u32].a r32 into r33;
    sign.verify r3[2u32].sig r3[2u32].a r32 into r34;
    is.eq r33 r34 into r35;
    is.eq r3[2u32].null true into r36;
    is.eq r35 r36 into r37;
    add r27 r3[2u32].oracle_price.price into r38;
    ternary r37 r38 r27 into r39;
    add r29 1u8 into r40;
    ternary r37 r40 r29 into r41;
    call data_checker r3[3u32] r0 r1 r2;
    add r3[3u32].oracle_price.price_key r3[3u32].oracle_price.price into r42;
    cast r3[3u32].oracle_price.height into r43 as u64;
    add r42 r43 into r44;
    sign.verify r3[3u32].sig r3[3u32].a r44 into r45;
    sign.verify r3[3u32].sig r3[3u32].a r44 into r46;
    is.eq r45 r46 into r47;
    is.eq r3[3u32].null true into r48;
    is.eq r47 r48 into r49;
    add r39 r3[3u32].oracle_price.price into r50;
    ternary r49 r50 r39 into r51;
    add r41 1u8 into r52;
    ternary r49 r52 r41 into r53;
    call data_checker r3[4u32] r0 r1 r2;
    add r3[4u32].oracle_price.price_key r3[4u32].oracle_price.price into r54;
    cast r3[4u32].oracle_price.height into r55 as u64;
    add r54 r55 into r56;
    sign.verify r3[4u32].sig r3[4u32].a r56 into r57;
    sign.verify r3[4u32].sig r3[4u32].a r56 into r58;
    is.eq r57 r58 into r59;
    is.eq r3[4u32].null true into r60;
    is.eq r59 r60 into r61;
    add r51 r3[4u32].oracle_price.price into r62;
    ternary r61 r62 r51 into r63;
    add r53 1u8 into r64;
    ternary r61 r64 r53 into r65;
    call data_checker r3[5u32] r0 r1 r2;
    add r3[5u32].oracle_price.price_key r3[5u32].oracle_price.price into r66;
    cast r3[5u32].oracle_price.height into r67 as u64;
    add r66 r67 into r68;
    sign.verify r3[5u32].sig r3[5u32].a r68 into r69;
    sign.verify r3[5u32].sig r3[5u32].a r68 into r70;
    is.eq r69 r70 into r71;
    is.eq r3[5u32].null true into r72;
    is.eq r71 r72 into r73;
    add r63 r3[5u32].oracle_price.price into r74;
    ternary r73 r74 r63 into r75;
    add r65 1u8 into r76;
    ternary r73 r76 r65 into r77;
    call data_checker r3[6u32] r0 r1 r2;
    add r3[6u32].oracle_price.price_key r3[6u32].oracle_price.price into r78;
    cast r3[6u32].oracle_price.height into r79 as u64;
    add r78 r79 into r80;
    sign.verify r3[6u32].sig r3[6u32].a r80 into r81;
    sign.verify r3[6u32].sig r3[6u32].a r80 into r82;
    is.eq r81 r82 into r83;
    is.eq r3[6u32].null true into r84;
    is.eq r83 r84 into r85;
    add r75 r3[6u32].oracle_price.price into r86;
    ternary r85 r86 r75 into r87;
    add r77 1u8 into r88;
    ternary r85 r88 r77 into r89;
    call data_checker r3[7u32] r0 r1 r2;
    add r3[7u32].oracle_price.price_key r3[7u32].oracle_price.price into r90;
    cast r3[7u32].oracle_price.height into r91 as u64;
    add r90 r91 into r92;
    sign.verify r3[7u32].sig r3[7u32].a r92 into r93;
    sign.verify r3[7u32].sig r3[7u32].a r92 into r94;
    is.eq r93 r94 into r95;
    is.eq r3[7u32].null true into r96;
    is.eq r95 r96 into r97;
    add r87 r3[7u32].oracle_price.price into r98;
    ternary r97 r98 r87 into r99;
    add r89 1u8 into r100;
    ternary r97 r100 r89 into r101;
    gte r101 4u8 into r102;
    assert.eq r102 true;
    cast r101 into r103 as u64;
    div r99 r103 into r104;
    gt r104 r4 into r105;
    sub r104 r4 into r106;
    sub r4 r104 into r107;
    ternary r105 r106 r107 into r108;
    gt r5 r108 into r109;
    assert.eq r109 true;
    cast r0 r104 r1 r2 into r110 as OraclePrice;
    async price_aggregator r110 into r111;
    output r111 as aleooracle.aleo/price_aggregator.future;

finalize price_aggregator:
    input r0 as OraclePrice.public;
    assert.eq r0.height block.height;
    cast r0.price r0.decimal into r1 as PriceEntry;
    set r1 into price_quote[r0.price_key];
