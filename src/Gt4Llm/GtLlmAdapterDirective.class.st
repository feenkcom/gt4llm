Class {
	#name : #GtLlmAdapterDirective,
	#superclass : #GtLlmModelfileDirective,
	#category : #'Gt4Llm-Modelfiles'
}

{ #category : #accessing }
GtLlmAdapterDirective >> directiveKind [
	^ 'ADAPTER'
]

{ #category : #accessing }
GtLlmAdapterDirective >> treatText [
	^ self text
]
