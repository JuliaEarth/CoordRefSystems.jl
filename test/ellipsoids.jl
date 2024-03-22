@testset "Ellipsoids" begin
  @testset "APL🌎" begin
    🌎 = CoordRefSystems.APL🌎
    @test majoraxis(🌎) == 6.378137e6u"m"
    @test minoraxis(🌎) == 6.356751796311819e6u"m"
    @test eccentricity(🌎) == 0.08182017999605988
    @test eccentricity²(🌎) == 0.006694541854587638
    @test flattening(🌎) == 0.003352891869237217
    @test flattening⁻¹(🌎) == 298.25
  end

  @testset "Airy🌎" begin
    🌎 = CoordRefSystems.Airy🌎
    @test majoraxis(🌎) == 6.377563396e6u"m"
    @test minoraxis(🌎) == 6.356256909237285e6u"m"
    @test eccentricity(🌎) == 0.08167337387414189
    @test eccentricity²(🌎) == 0.006670539999985363
    @test flattening(🌎) == 0.0033408506414970775
    @test flattening⁻¹(🌎) == 299.3249646
  end

  @testset "Andrae🌎" begin
    🌎 = CoordRefSystems.Andrae🌎
    @test majoraxis(🌎) == 6.37710443e6u"m"
    @test minoraxis(🌎) == 6.355847415233334e6u"m"
    @test eccentricity(🌎) == 0.08158158833680278
    @test eccentricity²(🌎) == 0.006655555555555555
    @test flattening(🌎) == 0.0033333333333333335
    @test flattening⁻¹(🌎) == 300.0
  end

  @testset "AustSA🌎" begin
    🌎 = CoordRefSystems.AustSA🌎
    @test majoraxis(🌎) == 6.37816e6u"m"
    @test minoraxis(🌎) == 6.356774719195305e6u"m"
    @test eccentricity(🌎) == 0.08182017999605988
    @test eccentricity²(🌎) == 0.006694541854587638
    @test flattening(🌎) == 0.003352891869237217
    @test flattening⁻¹(🌎) == 298.25
  end

  @testset "BessNam🌎" begin
    🌎 = CoordRefSystems.BessNam🌎
    @test majoraxis(🌎) == 6.377483865e6u"m"
    @test minoraxis(🌎) == 6.356165382966326e6u"m"
    @test eccentricity(🌎) == 0.08169683122252751
    @test eccentricity²(🌎) == 0.006674372231802145
    @test flattening(🌎) == 0.003342773182174806
    @test flattening⁻¹(🌎) == 299.1528128
  end

  @testset "Bessel🌎" begin
    🌎 = CoordRefSystems.Bessel🌎
    @test majoraxis(🌎) == 6.377397155e6u"m"
    @test minoraxis(🌎) == 6.356078962818189e6u"m"
    @test eccentricity(🌎) == 0.08169683122252751
    @test eccentricity²(🌎) == 0.006674372231802145
    @test flattening(🌎) == 0.003342773182174806
    @test flattening⁻¹(🌎) == 299.1528128
  end

  @testset "CPM🌎" begin
    🌎 = CoordRefSystems.CPM🌎
    @test majoraxis(🌎) == 6.3757387e6u"m"
    @test minoraxis(🌎) == 6.356666221912113e6u"m"
    @test eccentricity(🌎) == 0.07729088379892023
    @test eccentricity²(🌎) == 0.0059738807184181895
    @test flattening(🌎) == 0.002991414639983248
    @test flattening⁻¹(🌎) == 334.29
  end

  @testset "Clrk66🌎" begin
    🌎 = CoordRefSystems.Clrk66🌎
    @test majoraxis(🌎) == 6.3782064e6u"m"
    @test minoraxis(🌎) == 6.3565838e6u"m"
    @test eccentricity(🌎) == 0.08227185422300431
    @test eccentricity²(🌎) == 0.006768657997291273
    @test flattening(🌎) == 0.0033900753039287908
    @test flattening⁻¹(🌎) == 294.9786982138982
  end

  @testset "Clrk80IGN🌎" begin
    🌎 = CoordRefSystems.Clrk80IGN🌎
    @test majoraxis(🌎) == 6.3782492e6u"m"
    @test minoraxis(🌎) == 6.356515e6u"m"
    @test eccentricity(🌎) == 0.08248325676341796
    @test eccentricity²(🌎) == 0.006803487646299935
    @test flattening(🌎) == 0.003407549520015647
    @test flattening⁻¹(🌎) == 293.4660212936269
  end

  @testset "Clrk80🌎" begin
    🌎 = CoordRefSystems.Clrk80🌎
    @test majoraxis(🌎) == 6.378249145e6u"m"
    @test minoraxis(🌎) == 6.3565149658284895e6u"m"
    @test eccentricity(🌎) == 0.08248321766287976
    @test eccentricity²(🌎) == 0.006803481196021999
    @test flattening(🌎) == 0.003407546283849287
    @test flattening⁻¹(🌎) == 293.4663
  end

  @testset "Danish🌎" begin
    🌎 = CoordRefSystems.Danish🌎
    @test majoraxis(🌎) == 6.3770192563e6u"m"
    @test minoraxis(🌎) == 6.355762525445666e6u"m"
    @test eccentricity(🌎) == 0.08158158833680278
    @test eccentricity²(🌎) == 0.006655555555555555
    @test flattening(🌎) == 0.0033333333333333335
    @test flattening⁻¹(🌎) == 300.0
  end

  @testset "Delmbr🌎" begin
    🌎 = CoordRefSystems.Delmbr🌎
    @test majoraxis(🌎) == 6.376428e6u"m"
    @test minoraxis(🌎) == 6.355957926163724e6u"m"
    @test eccentricity(🌎) == 0.08006397376141204
    @test eccentricity²(🌎) == 0.006410239894468077
    @test flattening(🌎) == 0.0032102728731942215
    @test flattening⁻¹(🌎) == 311.5
  end

  @testset "Engelis🌎" begin
    🌎 = CoordRefSystems.Engelis🌎
    @test majoraxis(🌎) == 6.37813605e6u"m"
    @test minoraxis(🌎) == 6.356751322721543e6u"m"
    @test eccentricity(🌎) == 0.08181927622836065
    @test eccentricity²(🌎) == 0.006694393962532781
    @test flattening(🌎) == 0.003352817674445427
    @test flattening⁻¹(🌎) == 298.2566
  end

  @testset "Evrst30🌎" begin
    🌎 = CoordRefSystems.Evrst30🌎
    @test majoraxis(🌎) == 6.377276345e6u"m"
    @test minoraxis(🌎) == 6.35607541314024e6u"m"
    @test eccentricity(🌎) == 0.0814729809826527
    @test eccentricity²(🌎) == 0.006637846630199687
    @test flattening(🌎) == 0.003324449296662885
    @test flattening⁻¹(🌎) == 300.8017
  end

  @testset "Evrst48🌎" begin
    🌎 = CoordRefSystems.Evrst48🌎
    @test majoraxis(🌎) == 6.377304063e6u"m"
    @test minoraxis(🌎) == 6.356103038993155e6u"m"
    @test eccentricity(🌎) == 0.0814729809826527
    @test eccentricity²(🌎) == 0.006637846630199687
    @test flattening(🌎) == 0.003324449296662885
    @test flattening⁻¹(🌎) == 300.8017
  end

  @testset "Evrst56🌎" begin
    🌎 = CoordRefSystems.Evrst56🌎
    @test majoraxis(🌎) == 6.377301243e6u"m"
    @test minoraxis(🌎) == 6.356100228368102e6u"m"
    @test eccentricity(🌎) == 0.0814729809826527
    @test eccentricity²(🌎) == 0.006637846630199687
    @test flattening(🌎) == 0.003324449296662885
    @test flattening⁻¹(🌎) == 300.8017
  end

  @testset "Evrst69🌎" begin
    🌎 = CoordRefSystems.Evrst69🌎
    @test majoraxis(🌎) == 6.377295664e6u"m"
    @test minoraxis(🌎) == 6.356094667915204e6u"m"
    @test eccentricity(🌎) == 0.0814729809826527
    @test eccentricity²(🌎) == 0.006637846630199687
    @test flattening(🌎) == 0.003324449296662885
    @test flattening⁻¹(🌎) == 300.8017
  end

  @testset "EvrstSS🌎" begin
    🌎 = CoordRefSystems.EvrstSS🌎
    @test majoraxis(🌎) == 6.377298556e6u"m"
    @test minoraxis(🌎) == 6.356097550300896e6u"m"
    @test eccentricity(🌎) == 0.0814729809826527
    @test eccentricity²(🌎) == 0.006637846630199687
    @test flattening(🌎) == 0.003324449296662885
    @test flattening⁻¹(🌎) == 300.8017
  end

  @testset "Fschr60m🌎" begin
    🌎 = CoordRefSystems.Fschr60m🌎
    @test majoraxis(🌎) == 6.378155e6u"m"
    @test minoraxis(🌎) == 6.3567733204827355e6u"m"
    @test eccentricity(🌎) == 0.08181333401693115
    @test eccentricity²(🌎) == 0.006693421622965943
    @test flattening(🌎) == 0.003352329869259135
    @test flattening⁻¹(🌎) == 298.3
  end

  @testset "Fschr60🌎" begin
    🌎 = CoordRefSystems.Fschr60🌎
    @test majoraxis(🌎) == 6.378166e6u"m"
    @test minoraxis(🌎) == 6.356784283607107e6u"m"
    @test eccentricity(🌎) == 0.08181333401693115
    @test eccentricity²(🌎) == 0.006693421622965943
    @test flattening(🌎) == 0.003352329869259135
    @test flattening⁻¹(🌎) == 298.3
  end

  @testset "Fschr68🌎" begin
    🌎 = CoordRefSystems.Fschr68🌎
    @test majoraxis(🌎) == 6.37815e6u"m"
    @test minoraxis(🌎) == 6.356768337244385e6u"m"
    @test eccentricity(🌎) == 0.08181333401693115
    @test eccentricity²(🌎) == 0.006693421622965943
    @test flattening(🌎) == 0.003352329869259135
    @test flattening⁻¹(🌎) == 298.3
  end

  @testset "GRS67🌎" begin
    🌎 = CoordRefSystems.GRS67🌎
    @test majoraxis(🌎) == 6.37816e6u"m"
    @test minoraxis(🌎) == 6.356774516090714e6u"m"
    @test eccentricity(🌎) == 0.08182056788221195
    @test eccentricity²(🌎) == 0.006694605328567654
    @test flattening(🌎) == 0.003352923712996414
    @test flattening⁻¹(🌎) == 298.247167427
  end

  @testset "GRS80🌎" begin
    🌎 = CoordRefSystems.GRS80🌎
    @test majoraxis(🌎) == 6.378137e6u"m"
    @test minoraxis(🌎) == 6.356752314140356e6u"m"
    @test eccentricity(🌎) == 0.08181919104281579
    @test eccentricity²(🌎) == 0.006694380022900787
    @test flattening(🌎) == 0.003352810681182319
    @test flattening⁻¹(🌎) == 298.257222101
  end

  @testset "GSK2011🌎" begin
    🌎 = CoordRefSystems.GSK2011🌎
    @test majoraxis(🌎) == 6.3781365e6u"m"
    @test minoraxis(🌎) == 6.356751757955603e6u"m"
    @test eccentricity(🌎) == 0.08181930154714191
    @test eccentricity²(🌎) == 0.0066943981056621395
    @test flattening(🌎) == 0.003352819752979053
    @test flattening⁻¹(🌎) == 298.2564151
  end

  @testset "Helmert🌎" begin
    🌎 = CoordRefSystems.Helmert🌎
    @test majoraxis(🌎) == 6.3782e6u"m"
    @test minoraxis(🌎) == 6.356818169627891e6u"m"
    @test eccentricity(🌎) == 0.08181333401693115
    @test eccentricity²(🌎) == 0.006693421622965943
    @test flattening(🌎) == 0.003352329869259135
    @test flattening⁻¹(🌎) == 298.3
  end

  @testset "Hough🌎" begin
    🌎 = CoordRefSystems.Hough🌎
    @test majoraxis(🌎) == 6.37827e6u"m"
    @test minoraxis(🌎) == 6.356794343434343e6u"m"
    @test eccentricity(🌎) == 0.08199188997902977
    @test eccentricity²(🌎) == 0.006722670022333322
    @test flattening(🌎) == 0.003367003367003367
    @test flattening⁻¹(🌎) == 297.0
  end

  @testset "IAU76🌎" begin
    🌎 = CoordRefSystems.IAU76🌎
    @test majoraxis(🌎) == 6.37814e6u"m"
    @test minoraxis(🌎) == 6.356755288157528e6u"m"
    @test eccentricity(🌎) == 0.08181922145552321
    @test eccentricity²(🌎) == 0.00669438499958795
    @test flattening(🌎) == 0.0033528131778969143
    @test flattening⁻¹(🌎) == 298.257
  end

  @testset "Intl🌎" begin
    🌎 = CoordRefSystems.Intl🌎
    @test majoraxis(🌎) == 6.378388e6u"m"
    @test minoraxis(🌎) == 6.3569119461279465e6u"m"
    @test eccentricity(🌎) == 0.08199188997902977
    @test eccentricity²(🌎) == 0.006722670022333322
    @test flattening(🌎) == 0.003367003367003367
    @test flattening⁻¹(🌎) == 297.0
  end

  @testset "Kaula🌎" begin
    🌎 = CoordRefSystems.Kaula🌎
    @test majoraxis(🌎) == 6.378163e6u"m"
    @test minoraxis(🌎) == 6.35677699208691e6u"m"
    @test eccentricity(🌎) == 0.08182154939812526
    @test eccentricity²(🌎) == 0.006694765945909852
    @test flattening(🌎) == 0.0033530042918454937
    @test flattening⁻¹(🌎) == 298.24
  end

  @testset "Krass🌎" begin
    🌎 = CoordRefSystems.Krass🌎
    @test majoraxis(🌎) == 6.378245e6u"m"
    @test minoraxis(🌎) == 6.356863018773047e6u"m"
    @test eccentricity(🌎) == 0.08181333401693115
    @test eccentricity²(🌎) == 0.006693421622965943
    @test flattening(🌎) == 0.003352329869259135
    @test flattening⁻¹(🌎) == 298.3
  end

  @testset "Lerch🌎" begin
    🌎 = CoordRefSystems.Lerch🌎
    @test majoraxis(🌎) == 6.378139e6u"m"
    @test minoraxis(🌎) == 6.356754291510342e6u"m"
    @test eccentricity(🌎) == 0.08181922145552321
    @test eccentricity²(🌎) == 0.00669438499958795
    @test flattening(🌎) == 0.0033528131778969143
    @test flattening⁻¹(🌎) == 298.257
  end

  @testset "MERIT🌎" begin
    🌎 = CoordRefSystems.MERIT🌎
    @test majoraxis(🌎) == 6.378137e6u"m"
    @test minoraxis(🌎) == 6.356752298215968e6u"m"
    @test eccentricity(🌎) == 0.08181922145552321
    @test eccentricity²(🌎) == 0.00669438499958795
    @test flattening(🌎) == 0.0033528131778969143
    @test flattening⁻¹(🌎) == 298.257
  end

  @testset "ModAiry🌎" begin
    🌎 = CoordRefSystems.ModAiry🌎
    @test majoraxis(🌎) == 6.377340189e6u"m"
    @test minoraxis(🌎) == 6.356034446e6u"m"
    @test eccentricity(🌎) == 0.08167337758351056
    @test eccentricity²(🌎) == 0.006670540605898685
    @test flattening(🌎) == 0.003340850945469264
    @test flattening⁻¹(🌎) == 299.32493736548236
  end

  @testset "Mprts🌎" begin
    🌎 = CoordRefSystems.Mprts🌎
    @test majoraxis(🌎) == 6.3973e6u"m"
    @test minoraxis(🌎) == 6.363806282722513e6u"m"
    @test eccentricity(🌎) == 0.10219487589499024
    @test eccentricity²(🌎) == 0.010443792659192456
    @test flattening(🌎) == 0.005235602094240838
    @test flattening⁻¹(🌎) == 191.0
  end

  @testset "NWL9D🌎" begin
    🌎 = CoordRefSystems.NWL9D🌎
    @test majoraxis(🌎) == 6.378145e6u"m"
    @test minoraxis(🌎) == 6.356759769488684e6u"m"
    @test eccentricity(🌎) == 0.08182017999605988
    @test eccentricity²(🌎) == 0.006694541854587638
    @test flattening(🌎) == 0.003352891869237217
    @test flattening⁻¹(🌎) == 298.25
  end

  @testset "NewIntl🌎" begin
    🌎 = CoordRefSystems.NewIntl🌎
    @test majoraxis(🌎) == 6.3781575e6u"m"
    @test minoraxis(🌎) == 6.3567722e6u"m"
    @test eccentricity(🌎) == 0.0818202326633595
    @test eccentricity²(🌎) == 0.006694550473086282
    @test flattening(🌎) == 0.003352896192983603
    @test flattening⁻¹(🌎) == 298.2496153900135
  end

  @testset "PZ90🌎" begin
    🌎 = CoordRefSystems.PZ90🌎
    @test majoraxis(🌎) == 6.378136e6u"m"
    @test minoraxis(🌎) == 6.356751361795686e6u"m"
    @test eccentricity(🌎) == 0.08181910643292266
    @test eccentricity²(🌎) == 0.006694366177481926
    @test flattening(🌎) == 0.0033528037351842955
    @test flattening⁻¹(🌎) == 298.25784
  end

  @testset "Plessis🌎" begin
    🌎 = CoordRefSystems.Plessis🌎
    @test majoraxis(🌎) == 6.376523e6u"m"
    @test minoraxis(🌎) == 6.355863e6u"m"
    @test eccentricity(🌎) == 0.08043334427521875
    @test eccentricity²(🌎) == 0.006469522871295866
    @test flattening(🌎) == 0.003240010268919284
    @test flattening⁻¹(🌎) == 308.64099709583735
  end

  @testset "SEAsia🌎" begin
    🌎 = CoordRefSystems.SEAsia🌎
    @test majoraxis(🌎) == 6.378155e6u"m"
    @test minoraxis(🌎) == 6.3567733205e6u"m"
    @test eccentricity(🌎) == 0.08181333398395606
    @test eccentricity²(🌎) == 0.006693421617570338
    @test flattening(🌎) == 0.0033523298665522586
    @test flattening⁻¹(🌎) == 298.3000002408657
  end

  @testset "SGS85🌎" begin
    🌎 = CoordRefSystems.SGS85🌎
    @test majoraxis(🌎) == 6.378136e6u"m"
    @test minoraxis(🌎) == 6.356751301568781e6u"m"
    @test eccentricity(🌎) == 0.08181922145552321
    @test eccentricity²(🌎) == 0.00669438499958795
    @test flattening(🌎) == 0.0033528131778969143
    @test flattening⁻¹(🌎) == 298.257
  end

  @testset "WGS60🌎" begin
    🌎 = CoordRefSystems.WGS60🌎
    @test majoraxis(🌎) == 6.378165e6u"m"
    @test minoraxis(🌎) == 6.356783286959437e6u"m"
    @test eccentricity(🌎) == 0.08181333401693115
    @test eccentricity²(🌎) == 0.006693421622965943
    @test flattening(🌎) == 0.003352329869259135
    @test flattening⁻¹(🌎) == 298.3
  end

  @testset "WGS66🌎" begin
    🌎 = CoordRefSystems.WGS66🌎
    @test majoraxis(🌎) == 6.378145e6u"m"
    @test minoraxis(🌎) == 6.356759769488684e6u"m"
    @test eccentricity(🌎) == 0.08182017999605988
    @test eccentricity²(🌎) == 0.006694541854587638
    @test flattening(🌎) == 0.003352891869237217
    @test flattening⁻¹(🌎) == 298.25
  end

  @testset "WGS72🌎" begin
    🌎 = CoordRefSystems.WGS72🌎
    @test majoraxis(🌎) == 6.378135e6u"m"
    @test minoraxis(🌎) == 6.356750520016094e6u"m"
    @test eccentricity(🌎) == 0.08181881066274871
    @test eccentricity²(🌎) == 0.006694317778266723
    @test flattening(🌎) == 0.003352779454167505
    @test flattening⁻¹(🌎) == 298.26
  end

  @testset "WGS84🌎" begin
    🌎 = CoordRefSystems.WGS84🌎
    @test majoraxis(🌎) == 6.378137e6u"m"
    @test minoraxis(🌎) == 6.356752314245179e6u"m"
    @test eccentricity(🌎) == 0.08181919084262149
    @test eccentricity²(🌎) == 0.0066943799901413165
    @test flattening(🌎) == 0.0033528106647474805
    @test flattening⁻¹(🌎) == 298.257223563
  end

  @testset "Walbeck🌎" begin
    🌎 = CoordRefSystems.Walbeck🌎
    @test majoraxis(🌎) == 6.376896e6u"m"
    @test minoraxis(🌎) == 6.3558348467e6u"m"
    @test eccentricity(🌎) == 0.081206822928863
    @test eccentricity²(🌎) == 0.006594548090199708
    @test flattening(🌎) == 0.0033027280513905754
    @test flattening⁻¹(🌎) == 302.78000018165636
  end
end
