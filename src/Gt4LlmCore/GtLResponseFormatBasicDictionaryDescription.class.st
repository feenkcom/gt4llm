Class {
	#name : #GtLResponseFormatBasicDictionaryDescription,
	#superclass : #Object,
	#instVars : [
		'schemaDictionary'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseFormatBasicDictionaryDescription >> asJsonSchema [
	^ schemaDictionary
]

{ #category : #accessing }
GtLResponseFormatBasicDictionaryDescription >> schemaDictionary [
	^ schemaDictionary
]

{ #category : #accessing }
GtLResponseFormatBasicDictionaryDescription >> schemaDictionary: anObject [
	schemaDictionary := anObject
]
