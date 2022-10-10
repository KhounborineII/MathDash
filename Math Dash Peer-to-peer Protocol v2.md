# Math Dash Peer-to-peer Protocol v.2
## Top-level Format:
```json
{
    "version": 2,   // The protocol version.
    "type": "",     // The packet type. This value determines what the `value' field will contain.
    "value": {}     // The payload carried by this packet. Format depends on `type'.
}
```
## Type-value Table
|     Type | Value                                       | Description
|        -:|-                                            |-
|`"invite"`|`{ "host": "host_ip_address" }`              | Sent by the host to another device to request a game.
|`"ignore"`|`{}`                                         | Sent by the host when an invite is canceled/times out.
|  `"rsvp"`|`{ "response": true\|false, "seed": 123 }`   | Sent by the invitee back to the host to initialize/cancel the game. If `response` is `false`, then `seed` will be `-1`; otherwise, `seed` will be a positive integer.
|`"update"`|`{ "new_score": 123 }`                       | Sent by both players during the game when they score one point.
|   `"end"`|`{ "final_score": 123 }`                     | Sent by both players at the end of the game to wrap up the game.
