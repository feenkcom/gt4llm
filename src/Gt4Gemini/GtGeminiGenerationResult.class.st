Class {
	#name : #GtGeminiGenerationResult,
	#superclass : #GtLlmEntity,
	#instVars : [
		'candidates',
		'usageMetaData',
		'modelVersion'
	],
	#category : #Gt4Gemini
}

{ #category : #accessing }
GtGeminiGenerationResult class >> leJsonV4Name [

	^ #gtGeminiGenerationResult
]

{ #category : #'as yet unclassified' }
GtGeminiGenerationResult class >> serializationProperties [
	^ {#candidates -> #candidates.
		#usageMetaData -> #usageMetaData.
		#modelVersion -> #modelVersion}
]

{ #category : #accessing }
GtGeminiGenerationResult >> candidates [
	^ candidates
]

{ #category : #accessing }
GtGeminiGenerationResult >> candidates: anObject [
	candidates := GtGeminiMessageCandidateGroup
			withAll: (anObject collect: [ :aCandidate | GtGtGeminiMessageCandidate from: aCandidate ])
]

{ #category : #'as yet unclassified' }
GtGeminiGenerationResult >> gtMessagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Candidates';
		priority: 1;
		object: [ self candidates ];
		view: #gtMessagesFor:
]

{ #category : #accessing }
GtGeminiGenerationResult >> modelVersion [
	^ modelVersion
]

{ #category : #accessing }
GtGeminiGenerationResult >> modelVersion: anObject [
	modelVersion := anObject
]

{ #category : #accessing }
GtGeminiGenerationResult >> usageMetaData [
	^ usageMetaData
]

{ #category : #accessing }
GtGeminiGenerationResult >> usageMetaData: anObject [
	usageMetaData := anObject
]
