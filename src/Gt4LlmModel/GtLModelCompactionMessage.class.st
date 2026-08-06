Class {
	#name : #GtLModelCompactionMessage,
	#superclass : #GtLModelMessage,
	#instVars : [
		'providerData',
		'rawData',
		'currentProvider'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelCompactionMessage >> accessor [
	^ currentProvider model userMessageEndpoint assistantMessageAccessor assistantMessage: self
]

{ #category : #accessing }
GtLModelCompactionMessage >> content [

	^ self accessor content
]

{ #category : #accessing }
GtLModelCompactionMessage >> contentText [
	^ self rawContent contentText
]

{ #category : #testing }
GtLModelCompactionMessage >> hasCompactionResponse [
	^ true
]

{ #category : #testing }
GtLModelCompactionMessage >> hasContent [

	^ self rawContent isNotNil
]

{ #category : #accessing }
GtLModelCompactionMessage >> hasResponse [
	^ self rawContent notNil
]

{ #category : #initialization }
GtLModelCompactionMessage >> initialize [

	super initialize.
	providerData := IdentityDictionary new.
]

{ #category : #initialization }
GtLModelCompactionMessage >> initializeFromResult: aResult provider: aModelProvider [

	super initializeFromResult: aResult provider: aModelProvider.
	providerData at: aModelProvider put: aResult rawData.
	currentProvider := aModelProvider.
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawContent [

	^ self accessor
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawData [
	^ providerData at: currentProvider
]

{ #category : #'private - accessing' }
GtLModelCompactionMessage >> rawData: aRawData for: aModelProvider [
	"Set the rawData and provider for testing purposes."
	
	providerData at: aModelProvider put: aRawData.
	currentProvider := aModelProvider.
]

{ #category : #accessing }
GtLModelCompactionMessage >> role [
	^ 'assistant'
]
