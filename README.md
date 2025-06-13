# UCIe
TFM repo for implementation of UCie v2.0 protocol

Aiming for standard package 16 lanes with the following functionalities (for now):
- :green_circle: Data transfer in MainBand
- :green_circle: Sideband Communication
- :yellow_circle: Link state management
    - :green_circle: SB encode/decode
    - :green_circle: LTSM + Empty frames for each state
    - :green_circle: SBINIT
    - :yellow_circle: MBINIT
    - :red_circle: MBTRAIN
    - :red_circle: LINKINIT
    - :red_circle: ACTIVE
- :red_circle: Parameter negotiation
- :red_circle: Custom streaming protocol
