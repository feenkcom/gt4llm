Class {
	#name : #GtLResponseStringFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLResponseStringFormat class >> named: aName [
	^ self new 
		name: aName
]

{ #category : #initialization }
GtLResponseStringFormat >> initialize [
	super initialize.
	
	schema := NeoJSONSchema new
					json: (NeoJSONObject
							fromString: '
							{
			"type" : "string"
		}')
]

{ #category : #'neo json' }
GtLResponseStringFormat >> nextEntryFromNeoJsonReader: jsonReader [
	| string |
	string := super nextEntryFromNeoJsonReader: jsonReader.
	^GtLString forString: string
]

{ #category : #printing }
GtLResponseStringFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseStringFormat >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponseStringFormat >> type [
	^ schema type
]
