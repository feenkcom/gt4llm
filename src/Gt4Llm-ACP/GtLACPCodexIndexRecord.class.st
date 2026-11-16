"
I represent an entry in session_index.jsonl and explain its title and update timestamp.
"
Class {
	#name : #GtLACPCodexIndexRecord,
	#superclass : #GtLACPCodexSessionRecord,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #metadata }
GtLACPCodexIndexRecord >> dateKeys [
	^ #('updated_at')
]

{ #category : #initialization }
GtLACPCodexIndexRecord >> initialize [
	super initialize.
	format := #codexIndex
]

{ #category : #testing }
GtLACPCodexIndexRecord >> isIndexRecord [
	^ true
]

{ #category : #metadata }
GtLACPCodexIndexRecord >> metadataKeys [
	^ #('id' 'thread_name' 'name' 'updated_at')
]

{ #category : #accessing }
GtLACPCodexIndexRecord >> selectionReason [
	self == session titleRecord ifTrue: [ ^ 'Selected title' ].
	self updatedAt ifNil: [ ^ 'No valid update time' ].
	^ 'Older or superseded index record'
]

{ #category : #accessing }
GtLACPCodexIndexRecord >> title [
	^ metadata at: 'thread_name' ifAbsent: [ metadata at: 'name' ifAbsent: [ '' ] ]
]

{ #category : #accessing }
GtLACPCodexIndexRecord >> updatedAt [
	^ self dateAt: 'updated_at'
]
