Class {
	#name : #GtLCodeTransformations,
	#superclass : #GtLBasicTransformations,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLCodeTransformations >> allowedTransformationClasses [
	^ GtLCodeTransformationSpecification allSubclasses 
			select: #isConcrete
]
