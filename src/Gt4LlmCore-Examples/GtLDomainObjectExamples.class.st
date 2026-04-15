Class {
	#name : #GtLDomainObjectExamples,
	#superclass : #Object,
	#traits : 'TGtLDataBlockSerializationAssertions + TGtLDataViewAssertions',
	#classTraits : 'TGtLDataBlockSerializationAssertions classTrait + TGtLDataViewAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLDomainObjectExamples >> assertDataBlock: aDataBlock hasLlmJsonData: expectedJsonData [
	"Assert that aDataBlock llmJsonData equals expectedJsonData."
	self assert: aDataBlock llmJsonData equals: expectedJsonData
]

{ #category : #assertions }
GtLDomainObjectExamples >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	self assert: jsonData keys sorted equals: expectedKeys sorted
]
