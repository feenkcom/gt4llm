Class {
	#name : #GtLResponseInvividualFormat,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'neo json' }
GtLResponseInvividualFormat >> appendNeoJsonMappingTo: mapper [
	"By default add no mappings"
]

{ #category : #converting }
GtLResponseInvividualFormat >> asJsonSchemaDictionary [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLResponseInvividualFormat >> name [
	^ name
]

{ #category : #accessing }
GtLResponseInvividualFormat >> name: aString [
	name := aString
]

{ #category : #'neo json' }
GtLResponseInvividualFormat >> nextEntryFromNeoJsonReader: jsonReader [
	^ jsonReader next
]

{ #category : #'neo json' }
GtLResponseInvividualFormat >> readDomainObjectsFrom: aString [
	| neoJsonMapper |
	
	neoJsonMapper := NeoJSONReader on: aString readStream.
	
	self appendNeoJsonMappingTo: neoJsonMapper.
	^ self nextEntryFromNeoJsonReader: neoJsonMapper
]

{ #category : #'neo json' }
GtLResponseInvividualFormat >> readGenericDomainObjectsFrom: aString [
	^ self readDomainObjectsFrom: aString
]
