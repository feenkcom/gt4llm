Class {
	#name : #GtLDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLDomainObjectExamples >> classDomainObject [
	<gtExample>
	| aDomainObject aJsonObject aValidator |
	aDomainObject := GtLClassDomainObject new
		foundClass: GtLDummyOneObject;
		originalClassName: 'GtLDummyOneObject';
		originalSuperclassName: 'Object';
		originalPackageName: 'Gt4LlmCore-Examples';
		originalInstanceVariableNames: 'instVarA instVarB';
		originalClassVariableNames: 'classInstVarA classInstVarB';
		originalTraitCompositionString: Behavior traitCompositionString;
		yourself.
	aJsonObject := aDomainObject serializeToLlmJsonObject.

	aValidator := GtLValueSerializer new validateClass: aJsonObject.
	self assert: aValidator isValid.
	self assert: aDomainObject originalClassName equals: 'GtLDummyOneObject'.
	self assert: aDomainObject originalSuperclassName equals: 'Object'.
	self assert: aDomainObject originalPackageName equals: 'Gt4LlmCore-Examples'.
	self assert: aDomainObject originalInstanceVariableNames equals: 'instVarA instVarB'.
	self assert: aDomainObject originalClassVariableNames equals: 'classInstVarA classInstVarB'.
	self assert: aDomainObject originalTraitCompositionString equals: Behavior traitCompositionString.

	^ aDomainObject
]

{ #category : #'examples - class' }
GtLDomainObjectExamples >> missingArgumentDomainObject [
	<gtExample>
	| domainObject jsonObject |
	domainObject := GtLMissingArgumentDomainObject new
			missingArgument: 'className';
			arguments: (OrderedDictionary new
					at: #argumentOne put: 108;
					yourself).
					
	self assert: domainObject isErrorDomainObject.
	self
		assert: domainObject missingArgument
		equals: 'className'.
	self
		assert: domainObject errorMessage
		equals: 'Missing argument called className'.
	
	jsonObject := domainObject serializeToLlmJsonObject.
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'missingArgument' 
				put: 'className'; 
			at: 'errorMessage'
				put: 'Missing argument called className';
			yourself).


	^ domainObject
]

{ #category : #'examples - class' }
GtLDomainObjectExamples >> missingDomainObject [
	<gtExample>
	| domainObject jsonObject |
	domainObject := GtLMissingDomainObject new 
		objectName: GtLDummyOneObject name.
		
	self assert: domainObject isErrorDomainObject.
	self
		assert: domainObject missingObjectName
		equals: 'GtLDummyOneObject'.
	self
		assert: domainObject errorMessage
		equals: 'GtLDummyOneObject is not found'.
	
	jsonObject := domainObject serializeToLlmJsonObject.
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'missingObjectName' 
				put: 'GtLDummyOneObject'; 
			at: 'errorMessage'
				put: 'GtLDummyOneObject is not found';
			yourself).

	^ domainObject
]
