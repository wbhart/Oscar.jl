@testset "mpoly-loc constructors" begin
  R, (x, y, z) = PolynomialRing(QQ, ["x", "y", "z"])
  m = ideal(R, [y - 1, x - 2, z - 3])
  Q = Localization(R, m)
  I = ideal(Q, [x - 2, (y - 1)^2*z])
  a = Q(x//(1 + x))

  @test I.gens.O == Q.([x - 2, y^2*z - 2*y*z + z])
  @test a.frac == x // (1 + x)
end

@testset "mpoly-loc operations" begin
  R, (x, y, z) = PolynomialRing(QQ, ["x", "y", "z"])
  m = ideal(R, [y - 1, x - 2, z - 3])
  Q = Localization(R, m)
  I = ideal(Q, [x - 2, (y - 1)^2*z])
  J = ideal(Q, [x - 2, y - 1])
  a = Q(x//(1 + x))
  b = Q((x + y)//(3 + x - y))

  K1 = I+J
  K2 = I*J
  K3 = J^3
  c1 = a+b
  c2 = a*b

  @test K1.gens.O == Q.([x - 2, y^2*z - 2*y*z + z, y - 1])
  @test K2.gens.O == Q.([x^2 - 4*x + 4, x*y - x - 2*y + 2, x*y^2*z - 2*x*y*z + x*z - 2*y^2*z + 4*y*z - 2*z, y^3*z - 3*y^2*z + 3*y*z - z])
  @test K3.gens.O == Q.([x^3 - 6*x^2 + 12*x - 8, x^2*y - x^2 - 4*x*y + 4*x + 4*y - 4, x*y^2 - 2*x*y + x - 2*y^2 + 4*y - 2, y^3 - 3*y^2 + 3*y - 1])
  @test c1.frac == (x*(3 + x - y) + (1 + x)*(x + y))//((1 + x)*(3 + x - y))
  @test c2.frac == (x*(x + y))//((1 + x)*(3 + x - y))
end

@testset "mpoly-loc groebner" begin
  R, (x, y, z) = PolynomialRing(QQ, ["x", "y", "z"])
  m = ideal(R, [y - 1, x - 2, z - 3])
  Q = Localization(R, m)
  I = ideal(Q, [x - 2, (y - 1)^2*z])
  J = ideal(Q, [x - 1, y - 1])

  groebner_basis(I)
  groebner_basis(J)
  @test I.gb.O == Q.([x - 2, (y - 1)^2])
  @test J.gb.O == [one(Q)]
end
