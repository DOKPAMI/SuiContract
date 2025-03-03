module dokpami::dokpami_public{
  use std::string::{String};
  use sui::package;
  use sui::display;
  
  public struct DOKPAMI_PUBLIC has drop {}

  public struct DokpamiPublicNFT has key, store {
    id: UID,
    creator: address,
    mint_number: u64,
    name: String,
    department: String,
    description: String,
    img_url: String,
  }

  public struct DokpamiMintCount has key {
    id: UID,
    minted_number: u64
  }

  fun init(otw: DOKPAMI_PUBLIC, ctx: &mut TxContext) {
    let publisher = package::claim(otw, ctx);
    let mut display = display::new<DokpamiPublicNFT>(&publisher, ctx);

    display.add(b"creator".to_string(), b"{creator}".to_string());
    display.add(b"mint_number".to_string(), b"{mint_number}".to_string());
    display.add(b"name".to_string(), b"{name}".to_string());
    display.add(b"department".to_string(), b"{department}".to_string());
    display.add(b"description".to_string(), b"{description}".to_string());
    display.add(b"img_url".to_string(), b"{img_url}".to_string());

    transfer::public_transfer(display, ctx.sender());
    transfer::public_transfer(publisher, ctx.sender());

    transfer::share_object(DokpamiMintCount{
      id: object::new(ctx),
      minted_number: 0
    });
  }

  entry fun mint_dokpami_public(mint_count: &mut DokpamiMintCount, name: String, department: String, description: String, img_url: String, ctx: &mut TxContext) {
    let nft = new_dokpami_public(mint_count, name, department, description, img_url, ctx);
    transfer::transfer(nft, ctx.sender());
  }

  public fun new_dokpami_public(mint_count: &mut DokpamiMintCount, name: String, department: String, description: String, img_url: String, ctx: &mut TxContext): DokpamiPublicNFT {
    mint_count.plus_mint_count();
    DokpamiPublicNFT {
      id: object::new(ctx),
      creator: ctx.sender(),
      mint_number: mint_count.minted_number,
      name,
      department,
      description,
      img_url
    }
  }

  fun plus_mint_count(mint_count: &mut DokpamiMintCount) {
    mint_count.minted_number = mint_count.minted_number + 1;
  }

}


