"
Abstract superclass for examples testing GtLAbstractFunctionTool and its subclasses.
"
Class {
	#name : #GtLAbstractFunctionToolExamples,
	#superclass : #Object,
	#traits : 'TGtLDataBlockSerializationAssertions + TGtLDataViewAssertions + TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLDataBlockSerializationAssertions classTrait + TGtLDataViewAssertions classTrait + TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #assertions }
GtLAbstractFunctionToolExamples >> assertProblem: aDomainObject withErrorMessage: anErrorMessage [
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLProblemDomainObject).
	self assert: aDomainObject errorMessage equals: anErrorMessage.
	self assert: aDomainObject messageText equals: anErrorMessage
]
