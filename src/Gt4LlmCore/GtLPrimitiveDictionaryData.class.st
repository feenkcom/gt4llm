Class {
	#name : #GtLPrimitiveDictionaryData,
	#superclass : #GtLPrimitiveData,
	#instVars : [
		'dictionary'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPrimitiveDictionaryData class >> for: aDictionary [ 
	^ self new 
		dictionary: aDictionary
]

{ #category : #accessing }
GtLPrimitiveDictionaryData >> dictionary [
	^ dictionary
]

{ #category : #accessing }
GtLPrimitiveDictionaryData >> dictionary: anObject [
	dictionary := anObject
]

{ #category : #serialization }
GtLPrimitiveDictionaryData >> serializeToOpenAIResponseJsonString [
	"Return a JSON string that represents the domain object."

	<return: #String>
	^ STONJSON toString: self dictionary
]

{ #category : #serialization }
GtLPrimitiveDictionaryData >> serializeToOpenAIResponseOutput [

	<return: #NeoJSONObject>
	^ NeoJSONObject new
			at: #text put: self serializeToOpenAIResponseJsonString;
			at: #type put: #input_text;
			yourself
]
