Class {
	#name : #GtLBasicMessage,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Core'
}

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
