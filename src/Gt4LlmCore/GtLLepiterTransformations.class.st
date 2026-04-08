Class {
	#name : #GtLLepiterTransformations,
	#superclass : #GtLBasicTransformations,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLLepiterTransformations >> allowedTransformationClasses [
	 ^ GtLLepiterTransformationSpecification allSubclasses 
				select: #isConcrete
]
