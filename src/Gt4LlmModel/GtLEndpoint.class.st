Class {
	#name : #GtLEndpoint,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'private - accessing' }
GtLEndpoint >> entityFromContext: aGtLContext [

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLEndpoint >> path [
	^ self subclassResponsibility
]
