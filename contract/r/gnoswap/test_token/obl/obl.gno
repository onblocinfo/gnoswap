package obl

import (
	"std"
	"strings"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ownable"
	"gno.land/p/demo/ufmt"

	"gno.land/r/demo/grc20reg"
)

var (
	Token, privateLedger = grc20.NewToken("Obl", "OBL", 6)
	UserTeller           = Token.CallerTeller()
	owner                = ownable.NewWithAddress("g17290cwvmrapvp869xfnhhawa8sm9edpufzat7d") // ADMIN
)

func init() {
	privateLedger.Mint(owner.Owner(), 100_000_000_000_000)
	cross(grc20reg.Register)(Token, "")
}

func TotalSupply() int64 {
	crossing()
	return UserTeller.TotalSupply()
}

func BalanceOf(owner std.Address) int64 {
	crossing()
	return UserTeller.BalanceOf(owner)
}

func Allowance(owner, spender std.Address) int64 {
	crossing()
	return UserTeller.Allowance(owner, spender)
}

func Transfer(to std.Address, amount int64) {
	crossing()
	checkErr(UserTeller.Transfer(to, amount))
}

func Approve(spender std.Address, amount int64) {
	crossing()
	checkErr(UserTeller.Approve(spender, amount))
}

func TransferFrom(from, to std.Address, amount int64) {
	crossing()
	checkErr(UserTeller.TransferFrom(from, to, amount))
}

func Burn(from std.Address, amount int64) {
	crossing()
	owner.AssertOwnedByPrevious()
	checkErr(privateLedger.Burn(from, amount))
}

func Render(path string) string {
	crossing()
	parts := strings.Split(path, "/")
	c := len(parts)

	switch {
	case path == "":
		return Token.RenderHome()
	case c == 2 && parts[0] == "balance":
		owner := std.Address(parts[1])
		balance := UserTeller.BalanceOf(owner)
		return ufmt.Sprintf("%d\n", balance)
	default:
		return "404\n"
	}
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}
