Class {
	#name : #GtLDomainObjectVisitor,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #visitor }
GtLDomainObjectVisitor >> visitGtLString: aGtLString [

	stream nextPut: aGtLString stringValue
]

{ #category : #visitor }
GtLDomainObjectVisitor >> visitNodes: aCollection [

	^ Array streamContents: [ :aStream |
		stream := aStream.
		aCollection do: [ :each |
			each acceptVisitor: self ] ].
]

{ #category : #visitor }
GtLDomainObjectVisitor >> visitWrappedObjectModel: aModel [

	aModel model acceptVisitor: self.
]
