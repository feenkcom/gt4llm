Class {
	#name : #GtLBasicMessage,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #visitor }
GtLBasicMessage >> acceptVisitor: aVisitor [

	^ aVisitor perform: ('visit', self class name asString, ':') asSymbol
		withArguments: { self }
]

{ #category : #'api - converting' }
GtLBasicMessage >> asElement [
	^ self asViewModel asElement
]

{ #category : #'api - converting' }
GtLBasicMessage >> asViewModel [
	^ self viewModelClass new message: self
]

{ #category : #'api - converting' }
GtLBasicMessage >> viewModelClass [
	^ GtLBasicMessageViewModel
]
