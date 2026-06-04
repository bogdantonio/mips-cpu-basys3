## 📂 Project Structure

### 🔧 Design Sources

* [Single Cycle](./single_cycle/single_cycle.srcs/sources_1/new/)
* [Pipeline](./pipeline/pipeline.srcs/sources_1/new/)

### 📐 Constraints

* [Single Cycle](./single_cycle/single_cycle.srcs/constrs_1/new/)
* [Pipeline](./pipeline/pipeline.srcs/constrs_1/new/)

---

## 🧠 MIPS ISA

### 🧾 Instruction Encoding Overview (16-bit ISA)

#### 🔷 R-Type

```
[15:13] [12:10] [9:7] [6:4] [3] [2:0]
 opcode    rs     rt    rd    sa  func
```

#### 🔶 I-Type

```
[15:13] [12:10] [9:7] [6:0]
 opcode    rs     rt  immediate
```

#### 🔺 J-Type

```
[15:13] [12:0]
 opcode jump_address
```

---

## 📋 Instruction Set

|  Type  | Opcode | Func | Instruction | Description            |
| :----: | :----: | :--: | :---------: | :--------------------- |
| R |   000  |  000 |     add     | rd = rs + rt           |
| R |   000  |  001 |     sub     | rd = rs - rt           |
| R |   000  |  010 |     sll     | rd = rt << sa          |
| R |   000  |  011 |     srl     | rd = rt >> sa          |
| R |   000  |  100 |     and     | rd = rs & rt           |
| R |   000  |  101 |      or     | rd = rs | rt           |
| R |   000  |  110 |     xor     | rd = rs ^ rt           |
| R |   000  |  111 |     slt     | set less than          |
| I |   001  |   —  |      lw     | load word               |
| I |   010  |   —  |      sw     | store word              |
| I |   011  |   —  |     beq     | branch equal         |
| I |   100  |   —  |     ble     | branch less/equal    |
| I |   101  |   —  |     bge     | branch greater/equal |
| I |   110  |   —  |     slti    | set less than immediate |
| J |   111  |   —  |     jmp     | jump to address |

---

## 🧾 Field Definitions

| Field | Meaning              |
| :---: | :------------------- |
|   rs  | source register      |
|   rt  | target register      |
|   rd  | destination register |
|   sa  | shift amount         |
|  func | function code        |

