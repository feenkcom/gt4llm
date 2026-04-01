Trait {
	#name : #TGtLExceptionDomainObjectAssertions,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #assertions }
TGtLExceptionDomainObjectAssertions >> assertExceptionDomainObject: aDomainObject withExceptionClass: anExceptionClass messageSubstring: aMessageSubstring [
	"Assert that the domain object has an exception with expected class and message."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: aDomainObject exception isNotNil.
	self assert: aDomainObject exception class equals: anExceptionClass.
	self assert: (aDomainObject messageText includesSubstring: aMessageSubstring)
]
