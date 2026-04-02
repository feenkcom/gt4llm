Class {
	#name : #GtLChangeTransformations,
	#superclass : #GtLBasicTransformations,
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLChangeTransformations >> allowedTransformationClasses [
	^ (GtLCodeTransformationSpecification allSubclasses
		, GtLLepiterTransformationSpecification allSubclasses) select: #isConcrete
]
