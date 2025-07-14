Class {
    #name : #BaselineOfGt4HuggingFace,
    #superclass : #BaselineOf,
    #category : #BaselineOfGt4HuggingFace
}

{ #category : #baseline }
BaselineOfGt4HuggingFace >> baseline: spec [
    <baseline>
    ^ spec
        for: #common
        do: [ spec
                baseline: 'Gt4LlmCore'
                    with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].
            spec package: 'Gt4HuggingFace' with: [ spec requires: #('Gt4LlmCore') ] ]
]
