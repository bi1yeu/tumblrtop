describe "tests", ->
  it "runs", ->
    val = 5
    expect(val).toBe 5

  it "fails", ->
    val = 6
    expect(val).toBe 6