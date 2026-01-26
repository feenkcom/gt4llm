Extension { #name : #TestCase }

{ #category : #'*Gt4LlmCore' }
TestCase >> gtRunWithExplicitResult [
	| testWithResult |
	testWithResult := GtLSUnitTestWithResult new
		testCase: self.
	testWithResult run.
	^ testWithResult 
]
