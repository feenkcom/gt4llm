Class {
	#name : #GtLResponsePlainStringFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLResponsePlainStringFormat class >> named: aName [
	^ self new 
		name: aName
]

{ #category : #initialization }
GtLResponsePlainStringFormat >> initialize [
	super initialize.
	
	schema := NeoJSONSchema new
					json: (NeoJSONObject
							fromString: '
							{
			"type" : "string"
		}')
]

{ #category : #printing }
GtLResponsePlainStringFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponsePlainStringFormat >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponsePlainStringFormat >> type [
	^ schema type
]
