Class {
	#name : #GtLlmSerializableValueHolder,
	#superclass : #GtLlmValueHolder,
	#instVars : [
		'serializer',
		'updater'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmSerializableValueHolder >> contentValue [
	^ self serializer value: self content
]

{ #category : #'as yet unclassified' }
GtLlmSerializableValueHolder >> gtSerializedFor: aView [
	<gtView>
	^ aView explicit
		title: 'Serialized';
		priority: 2;
		stencil: [ (self contentValue gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
]

{ #category : #'as yet unclassified' }
GtLlmSerializableValueHolder >> initialize [
	super initialize.

	updater := [ :_ :aValue | self content: aValue ].
	serializer := #yourself
]

{ #category : #accessing }
GtLlmSerializableValueHolder >> serializer [
	^ serializer
]

{ #category : #accessing }
GtLlmSerializableValueHolder >> serializer: anObject [
	serializer := anObject
]

{ #category : #'as yet unclassified' }
GtLlmSerializableValueHolder >> updateContent: aValue [
	self updater cull: content cull: aValue
]

{ #category : #accessing }
GtLlmSerializableValueHolder >> updater [
	^ updater
]

{ #category : #accessing }
GtLlmSerializableValueHolder >> updater: anObject [
	updater := anObject
]
