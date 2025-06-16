@testset "rand" begin
  @testset "Basic" begin
    for C in basic
      randtest(C{NoDatum})
      randtest(C)
    end
  end

  @testset "Geographic" begin
    for C in geographic
      randtest(C{WGS84Latest})
      randtest(C)
    end
  end

  @testset "Projected" begin
    for C in projected
      randtest(C{WGS84Latest})
      randtest(C)
    end
  end
end
